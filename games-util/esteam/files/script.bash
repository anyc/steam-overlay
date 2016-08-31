#!/bin/bash
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

source "@GENTOO_PORTAGE_EPREFIX@/lib/gentoo/functions.sh"
set -e # Gentoo bug #592470

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

  Only a specific list of games will have their bundled libraries
  deleted in favor of system versions where possible. This list
  excludes games that are VAC enabled or known to break when
  unbundled. Additions to this list are welcome.
EOF

			exit 1 ;;
	esac
done

shift $(( ${OPTIND} - 1 ))
declare -A LIBS UNBUNDLEABLES_A DIRS ATOMS ATOMS64 ATOMS32
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
GL_DRIVER=$(eselect opengl show || eerror "Error: Could not determine OpenGL driver")

unset IFS
for UNBUNDLEABLE in "${UNBUNDLEABLES[@]}"; do
	UNBUNDLEABLES_A[${UNBUNDLEABLE}]=1
done

IFS=$'\n'
for HOME in $(getent passwd | cut -d: -f6 | sort -u); do
	DIR=${HOME%/}/.steam/steam

	if [[ -d "${DIR}" ]]; then
		if [[ -d "${DIR}"/SteamApps/common ]]; then
			DIRS[${DIR}]=1
		fi

		IFS=$'\n'
		for DIR in $(grep -s $'^\t"[0-9][0-9]*"' "${DIR}"/SteamApps/libraryfolders.vdf | cut -d\" -f4); do
			if [[ -d "${DIR}"/SteamApps/common ]]; then
				DIRS[${DIR}]=1
			fi
		done
	fi
done

unset IFS
for DIR in "${!DIRS[@]}"; do
	COMMON=${DIR}/SteamApps/common/

	if [[ ! -w "${COMMON}" ]]; then
		ewarn "Skipping unwritable ${DIR}"
		continue
	fi

	einfo "Scanning ${DIR} ..."

	unset IFS
	for DELETEABLE in "${DELETEABLES[@]}"; do
		if [[ -f "${COMMON}${DELETEABLE}" ]]; then
			rm "${COMMON}${DELETEABLE}"
			einfo "Deleted: ${DELETEABLE}"
		fi
	done

	case "${ARCH}" in
		x86) SCAN_ARGS="-M 32" ;;
		*) unset SCAN_ARGS ;;
	esac

	SCAN_RESULT=$(scanelf ${SCAN_ARGS} -BRF $'%F\t%a\t%n' "${COMMON}")

	unset BINARIES
	declare -A BINARIES

	IFS=$'\n'
	for SCAN_LINE in ${SCAN_RESULT}; do
		IFS=$'\t' read SCANNED_PATH EM NEEDEDS <<< "${SCAN_LINE}"

		GAME=${SCANNED_PATH#${COMMON}}
		GAME=${GAME%%/*}

		SCANNED_ATOM=${LIBS[${SCANNED_PATH##*/}]}

		if [[ -n "${SCANNED_ATOM}" && ${UNBUNDLEABLES_A[${GAME}]} = 1 ]]; then
			rm "${SCANNED_PATH}"
			einfo "Deleted: ${SCANNED_PATH#${COMMON}}"
			continue
		fi

		SCANNED_PATH=${SCANNED_PATH#${COMMON}}
		BINARIES[${SCANNED_PATH%%/*}/${EM}/${SCANNED_PATH##*/}]=1
	done

	IFS=$'\n'
	for SCAN_LINE in ${SCAN_RESULT}; do
		IFS=$'\t' read SCANNED_PATH EM NEEDEDS <<< "${SCAN_LINE}"
		[[ ! -e "${SCANNED_PATH}" ]] && continue

		GAME=${SCANNED_PATH#${COMMON}}
		GAME=${GAME%%/*}

		IFS=$'\n'
		for MATCH in $(grep -Eao "Adobe AIR|S3TC" "${SCANNED_PATH}" | sort -u); do
			case "${MATCH}" in
				"Adobe AIR") ATOMS[dev-util/adobe-air-runtime]=1 ;;
				"S3TC") [[ "${GL_DRIVER}" = xorg-x11 ]] && NEEDEDS+=,libtxc_dxtn.so ;;
			esac
		done

		IFS=','
		for NEEDED_FILE in ${NEEDEDS}; do
			NEEDED_ATOM=${LIBS[${NEEDED_FILE}]}
			MSG="${NEEDED_FILE} needed by ${SCANNED_PATH#${COMMON}}"

			if [[ ${BINARIES[${GAME}/${EM}/${NEEDED_FILE}]} = 1 ]]; then
				if [[ -n "${NEEDED_ATOM}" ]]; then
					vewarn "Skipped: ${MSG}" && true
				else
					vewarn "Bundled: ${MSG}" && true
				fi
			else
				if [[ "${NEEDED_FILE}" = libGL.so* ]]; then
					case "${GL_DRIVER}" in
						ati) NEEDED_ATOM=x11-drivers/ati-drivers[@ABI@] ;;
						nvidia) NEEDED_ATOM=x11-drivers/nvidia-drivers[@MULTILIB@] ;;
						xorg-x11) NEEDED_ATOM=media-libs/mesa[@ABI@] ;;
					esac
				fi

				if [[ -n "${NEEDED_ATOM}" ]]; then
					case "${EM}" in
						EM_X86_64) ATOMS64[${NEEDED_ATOM}]=1 ;;
						EM_386) ATOMS32[${NEEDED_ATOM}]=1 ;;
					esac
				else
					eerror "Unknown: ${MSG}" && true
				fi
			fi
		done
	done

	IFS=$'\n'
	for MATCH in $(find "${COMMON}" -type f -exec awk '/^#!/ {print FILENAME} {nextfile}' {} + | xargs -d $'\n' grep -Eaoh "\b(xwininfo)\b" | sort -u); do
		case "${MATCH}" in
			"xwininfo") ATOMS[x11-apps/xwininfo]=1 ;;
		esac
	done
done

unset IFS
for ATOM in "${!ATOMS64[@]}" "${!ATOMS32[@]}"; do
	ATOMS[${ATOM}]=1
done

unset CONTENTS
SET="@GENTOO_PORTAGE_EPREFIX@/var/lib/portage/esteam"

unset IFS
for ATOM in $(printf "%s\n" "${!ATOMS[@]}" | sort); do
	if [[ "${ARCH}" != x86 && -n "${ATOMS32[${ATOM}]}" ]]; then
		ATOM=${ATOM//@MULTILIB@/multilib}
	else
		ATOM=${ATOM//@MULTILIB@}
	fi

	if [[ -n "${ATOMS64[${ATOM}]}" && -n "${ATOMS32[${ATOM}]}" ]]; then
		ATOM=${ATOM//@ABI@/abi_x86_64,abi_x86_32}
	elif [[ -n "${ATOMS64[${ATOM}]}" ]]; then
		ATOM=${ATOM//@ABI@/abi_x86_64}
	elif [[ -n "${ATOMS32[${ATOM}]}" ]]; then
		ATOM=${ATOM//@ABI@/abi_x86_32}
	fi

	ATOM=${ATOM//,\]/\]}
	ATOM=${ATOM//\[\]}
	CONTENTS+=${ATOM}$'\n'
done

echo
einfo "Writing Portage set to ${SET} ..."
echo -n "${CONTENTS}" | ${SUDO} tee "${SET}" >/dev/null

einfo "Executing emerge -an${@+ }${@} @esteam ..."
exec ${SUDO} emerge -an "${@}" @esteam
