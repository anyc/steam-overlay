#!@GENTOO_PORTAGE_EPREFIX@/bin/bash
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

source "@GENTOO_PORTAGE_EPREFIX@/lib/gentoo/functions.sh"
set -e # Gentoo bug #592470
shopt -s nullglob

while getopts vh OPT; do
	case "${OPT}" in
		v) EINFO_VERBOSE=yes ;;
		h)
			cat <<EOF
Usage: $0 [-h] [-v] -- [emerge options]
Scan Steam libraries to generate and emerge a Portage set.

Optional arguments:

  -h  Print this usage and exit
  -v  Be more verbose
  --  Remaining options are passed to emerge

Output:

  This tool will output information regarding the following states.

EOF

			eerror "Unknown: Required library has no system version and is not bundled" && true
			einfo  "Deleted: Library has been safely deleted in favor of a system version"
			ewarn  "Bundled: Library has no system version but is bundled (verbose)"
			ewarn  "Skipped: Library has a system version but remains bundled (verbose)"

			cat <<EOF

Notes:

  Deleted libraries can be easily restored by right-clicking on the game
  in Steam and navigating to Properties -> Local Files -> Verify
  Integrity of Game Cache.

  The official Steam runtime can be safely enabled or disabled as
  desired with no ill effects. If you wish to remove the libraries
  installed by this tool in favor of the runtime then execute:
  emerge --deselect @esteam && emerge --depclean

  To avoid unexpected breakage, only a specific list of games will
  have their bundled libraries deleted in favor of system versions
  where possible. Additions to this list are welcome.
EOF

			exit 1 ;;
	esac
done

shift $(( ${OPTIND} - 1 ))
declare -A LIBS UNBUNDLEABLES_A DIRS GAME_ATOMS
source "@GENTOO_PORTAGE_EPREFIX@/usr/share/esteam/database.bash"

if [[ ! -w "@GENTOO_PORTAGE_EPREFIX@/" ]]; then
	if type sudo &>/dev/null; then
		ewarn "esteam started as unprivileged user so scan may be incomplete"
		SUDO=sudo
	else
		eerror "Error: esteam started as unprivileged user and sudo unavailable"
	fi
else
	unset SUDO
fi

ARCH=$(portageq envvar ARCH || eerror "Error: Could not determine Portage ARCH")

unset IFS
for UNBUNDLEABLE in "${UNBUNDLEABLES[@]}"; do
	UNBUNDLEABLES_A[${UNBUNDLEABLE}]=1
done

IFS=$'\n'
for HOME in $(getent passwd | cut -d: -f6 | sort -u); do
	DIR=${HOME%/}/.steam/steam

	if [[ -d ${DIR} ]]; then
		if [[ -d ${DIR}/steamapps/common || -d ${DIR}/SteamApps/common ]]; then
			DIRS[${DIR}]=1
		fi

		IFS=$'\n'
		for DIR in $(grep -hs $'^\t"[0-9][0-9]*"' "${DIR}"/[Ss]team[Aa]pps/libraryfolders.vdf | cut -d\" -f4); do
			if [[ -d ${DIR}/steamapps/common || -d ${DIR}/SteamApps/common ]]; then
				DIRS[${DIR}]=1
			fi
		done
	fi
done

unset IFS
for DIR in "${!DIRS[@]}"; do
	for COMMON in "${DIR}"/steamapps/common/ "${DIR}"/SteamApps/common/; do
		if [[ ! -d ${COMMON} ]]; then
			continue
		elif [[ ! -w ${COMMON} ]]; then
			ewarn "Skipping unwritable ${DIR}"
			continue
		fi

		einfo "Scanning ${DIR} ..."

		unset IFS
		for DELETEABLE in "${DELETEABLES[@]}"; do
			if [[ -e ${COMMON}${DELETEABLE} ]]; then
				rm -r "${COMMON}${DELETEABLE}"
				einfo "Deleted: ${DELETEABLE}"
			fi
		done

		case "${ARCH}" in
			x86) SCAN_ARGS="-M 32" ;;
			*) unset SCAN_ARGS ;;
		esac

		# Reverse sort so that EM_X86_64 is handled before EM_386. This
		# ensures that if both a 32-bit and 64-bit JRE are found within
		# the same directory then 64-bit will take precedence.
		SCAN_RESULT=$(find "${COMMON}" -type f -name libjvm.so -exec scanelf ${SCAN_ARGS} -yBF $'%a\t%F' {} + | sort -r)

		IFS=$'\n'
		for SCAN_LINE in ${SCAN_RESULT}; do
			IFS=$'\t' read EM SCANNED_PATH <<< "${SCAN_LINE}"

			GAME=${SCANNED_PATH#${COMMON}}
			GAME=${GAME%%/*}

			if [[ ! -e ${SCANNED_PATH} || ${UNBUNDLEABLES_A[${GAME}]} != 1 ]]; then
				continue
			fi

			JAVA_ROOT=$(realpath -m "${SCANNED_PATH%/*}"/../../..)
			JAVA=$(! ls -- "${JAVA_ROOT}"/bin/java{,32,64} 2>/dev/null)

			if [[ -n ${JAVA} ]]; then
				GENTOO_JAVA="${COMMON}/${GAME}"/.gentoo-java

				mkdir -p "${GENTOO_JAVA}"
				echo "${JAVA//${COMMON}}" >> "${GENTOO_JAVA}"/bin

				if [[ $(cat "${GENTOO_JAVA}"/em 2>/dev/null) != EM_X86_64 ]]; then
					echo "${EM}" > "${GENTOO_JAVA}"/em
				fi

				chown -R --reference="${COMMON}" "${GENTOO_JAVA}"
				chmod -R --reference="${COMMON}" "${GENTOO_JAVA}"
				chmod a-sx "${GENTOO_JAVA}"/*

				if [[ ${JAVA_ROOT} = ${COMMON}${GAME} ]]; then
					rm -r "${JAVA_ROOT}"/{bin,lib}
					einfo "Deleted: ${JAVA_ROOT}/{bin,lib} (Java)"
				else
					rm -r "${JAVA_ROOT}"
					einfo "Deleted: ${JAVA_ROOT} (Java)"
				fi
			fi
		done

		unset IFS
		for GENTOO_JAVA in "${COMMON}"/*/.gentoo-java; do
			GAME=${GENTOO_JAVA%/*}
			GAME=${GAME##*/}

			EM=$(cat "${GENTOO_JAVA}"/em)
			BINS=$(cat "${GENTOO_JAVA}"/bin | sed "s:^:${COMMON}:")
			IFS=$'\n'

			for BIN in ${BINS}; do
				mkdir -p "${BIN%/*}"
			done

			if [[ ${EM} = EM_386 && ${ARCH} != x86 ]]; then
				GAME_ATOMS[${GAME}]+=dev-java/icedtea-bin:8[abi_x86_32,multilib]$'\n'
				cat <<EOF | tee ${BINS} >/dev/null
#!@GENTOO_PORTAGE_EPREFIX@/bin/sh
export GENTOO_VM=icedtea-bin-8-x86
exec "@GENTOO_PORTAGE_EPREFIX@/usr/bin/java" "\${@}"
EOF
		else
			ATOMS[virtual/jre:1.8]=1
			cat <<EOF | tee ${BINS} >/dev/null
#!@GENTOO_PORTAGE_EPREFIX@/bin/sh
@GENTOO_PORTAGE_EPREFIX@/usr/bin/depend-java-query -s "virtual/jre:1.8" >/dev/null || export GENTOO_VM=\$(@GENTOO_PORTAGE_EPREFIX@/usr/bin/depend-java-query -v "virtual/jre:1.8")
exec "@GENTOO_PORTAGE_EPREFIX@/usr/bin/java" "\${@}"
EOF
			fi

			for BIN in ${BINS}; do
				chown -R --reference="${COMMON}" "${BIN%/*}"
				chmod -R --reference="${COMMON}" "${BIN%/*}"
			done

			chmod a-s ${BINS}
		done

		SCAN_RESULT=$(scanelf ${SCAN_ARGS} -yBRF $'%F\t%a\t%n' "${COMMON}")

		IFS=$'\n'
		for SCANNED_PATH in $(find "${COMMON}" -type f -name FNA.dll.config); do
			MATCH=$(grep -F "${SCANNED_PATH%/*}" <<< "${SCAN_RESULT}") || continue
			NEEDEDS=$(printf '%s,' $(grep -Eo 'lib[^"]+\.so[^"]*' "${SCANNED_PATH}")) # FIXME: Use XPath
			[[ ${MATCH} = *$'\tEM_X86_64\t'* ]] && SCAN_RESULT+=$'\n'${SCANNED_PATH}$'\tEM_X86_64\t'${NEEDEDS%,}
			[[ ${MATCH} = *$'\tEM_386\t'* ]] && SCAN_RESULT+=$'\n'${SCANNED_PATH}$'\tEM_386\t'${NEEDEDS%,}
		done

		unset BINARIES
		declare -A BINARIES

		IFS=$'\n'
		for SCAN_LINE in ${SCAN_RESULT}; do
			IFS=$'\t' read SCANNED_PATH EM NEEDEDS <<< "${SCAN_LINE}"

			GAME=${SCANNED_PATH#${COMMON}}
			GAME=${GAME%%/*}

			# Valve's runtime should be self-contained.
			[[ ${GAME} = SteamLinuxRuntime ]] && continue

			SCANNED_ATOM=${LIBS[${SCANNED_PATH##*/}]}

			if [[ ${UNBUNDLEABLES_A[${GAME}]} = 1 ]]; then
				case "${SCANNED_ATOM}" in
					+|"")
						: ;;
					*/*)
						rm "${SCANNED_PATH}"
						einfo "Deleted: ${SCANNED_PATH#${COMMON}}"
						continue ;;
					*)
						case "${EM}" in
							EM_X86_64) LIBDIR=$(portageq envvar LIBDIR_amd64) ;;
							EM_386) LIBDIR=$(portageq envvar LIBDIR_x86) ;;
						esac

						[[ -n ${LIBDIR} ]] || eerror "Error: Could not determine Portage LIBDIR"
						TARGET="@GENTOO_PORTAGE_EPREFIX@/usr/${LIBDIR}/${SCANNED_ATOM}"
						ln -snf "${TARGET}" "${SCANNED_PATH}"
						einfo "Symlinked: ${SCANNED_PATH#${COMMON}} to ${TARGET}"
						continue ;;
				esac
			fi

			SCANNED_PATH=${SCANNED_PATH#${COMMON}}
			BINARIES[${SCANNED_PATH%%/*}/${EM}/${SCANNED_PATH##*/}]=1
		done

		IFS=$'\n'
		for SCAN_LINE in ${SCAN_RESULT}; do
			IFS=$'\t' read SCANNED_PATH EM NEEDEDS <<< "${SCAN_LINE}"
			[[ ! -e ${SCANNED_PATH} ]] && continue

			GAME=${SCANNED_PATH#${COMMON}}
			GAME=${GAME%%/*}

			# Valve's runtime should be self-contained.
			[[ ${GAME} = SteamLinuxRuntime ]] && continue

			IFS=$'\n'
			for MATCH in $(grep -Eao "Adobe AIR" "${SCANNED_PATH}" | sort -u); do
				case "${MATCH}" in
					"Adobe AIR") GAME_ATOMS[${GAME}]+=dev-util/adobe-air-runtime$'\n' ;;
				esac
			done

			IFS=','
			for NEEDED_FILE in ${NEEDEDS}; do
				NEEDED_ATOM=${LIBS[${NEEDED_FILE}]}
				[[ ${NEEDED_ATOM} = + ]] && continue
				MSG="${NEEDED_FILE} needed by ${SCANNED_PATH#${COMMON}}"

				if [[ ${BINARIES[${GAME}/${EM}/${NEEDED_FILE}]} = 1 ]]; then
					if [[ -n ${NEEDED_ATOM} ]]; then
						vewarn "Skipped: ${MSG}" && true
					else
						vewarn "Bundled: ${MSG}" && true
					fi
				else
					if [[ -n ${NEEDED_ATOM} && ${NEEDED_ATOM} != */* ]]; then
						NEEDED_ATOM=${LIBS[${NEEDED_ATOM}]}
					fi

					if [[ -n ${NEEDED_ATOM} ]]; then
						unset ATOM

						case "${EM}" in
							EM_X86_64) ATOM=${NEEDED_ATOM//@ABI@/abi_x86_64} ;;
							EM_386) ATOM=${NEEDED_ATOM//@ABI@/abi_x86_32} ;;
						esac

						if [[ -n ${ATOM} ]]; then
							if [[ ${ARCH} != x86 && ${EM} = EM_386 ]]; then
								ATOM=${ATOM//@MULTILIB@/multilib}
							else
								ATOM=${ATOM//@MULTILIB@}
							fi

							ATOM=${ATOM//\[,/\[}
							ATOM=${ATOM//,\]/\]}
							ATOM=${ATOM//\[\]}
							GAME_ATOMS[${GAME}]+=${ATOM}$'\n'
						fi
					else
						eerror "Unknown: ${MSG}" && true
					fi
				fi
			done
		done

		IFS=$'\n'
		for MATCH in $(find "${COMMON}" -type f -exec awk '/^#!/ {print FILENAME} {nextfile}' {} + | xargs -d $'\n' grep -Eaoh "\b(xwininfo)\b" | sort -u); do
			case "${MATCH}" in
				"xwininfo") GAME_ATOMS["Miscellaneous"]+=x11-apps/xwininfo$'\n' ;;
			esac
		done
	done
done

unset CONTENTS
SET="@GENTOO_PORTAGE_EPREFIX@/etc/portage/sets/esteam"

unset IFS
for GAME in "${!GAME_ATOMS[@]}"; do
	CONTENTS+="# ${GAME}$(sort -u <<< ${GAME_ATOMS[${GAME}]})"$'\n\n'
done

echo
einfo "Writing Portage set to ${SET} ..."
${SUDO} mkdir -p "${SET%/*}"
${SUDO} tee "${SET}" <<< ${CONTENTS%$'\n\n'} >/dev/null

einfo "Executing emerge -an${@+ }${@} @esteam ..."
exec ${SUDO} emerge -an "${@}" @esteam
