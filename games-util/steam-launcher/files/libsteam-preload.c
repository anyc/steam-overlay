/* Copyright 1999-2019 Gentoo Authors */
/* Distributed under the terms of the GNU General Public License v2 */

#define _GNU_SOURCE

#include <dlfcn.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define STEAM_PRELOAD_QUOTE(name) #name
#define STEAM_PRELOAD_STR(macro) STEAM_PRELOAD_QUOTE(macro)
#define GLIBDIR_STR STEAM_PRELOAD_STR(GLIBDIR)

int (*execve_real)(const char *filename, char *const argv[], char *const envp[]) = NULL;

int execve(const char *filename, char *const argv[], char *const envp[]) {
	if (execve_real == NULL) {
		execve_real = dlsym(RTLD_NEXT, "execve");
	}

	if (strcmp(filename, "./steamwebhelper") == 0) {
		fputs("Gentoo caught steamwebhelper invocation\n", stderr);

		unsigned int i;
		for (i = 0; envp[i] != NULL; i++);
		char **envp2 = malloc(sizeof(char*) * i);

		if (envp2 == NULL) {
			errno = ENOMEM;
			return -1;
		}

		int ret;
		char *llp = NULL;

		for (i = 0; envp[i] != NULL; i++) {
			if (strncmp(envp[i], "LD_LIBRARY_PATH=", 16) == 0) {
				ret = asprintf(&llp, "LD_LIBRARY_PATH=" GLIBDIR_STR ":%s", envp[i] + 16);

				if (ret < 0) {
					free(envp2);
					errno = ENOMEM;
					return -1;
				}

				fprintf(stderr, "Gentoo reinvoking steamwebhelper with %s\n", llp);
				envp2[i] = llp;
			} else {
				envp2[i] = envp[i];
			}
		}

		envp2[i] = NULL;
		ret = execve_real(filename, argv, envp2);
		free(envp2);
		free(llp);
		return ret;
	} else {
		return execve_real(filename, argv, envp);
	}
}
