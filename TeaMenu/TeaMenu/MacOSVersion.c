//
//  MacOSVersion.c
//  TeaMenu
//
//  Created by Jan on 18.11.14.
//  Copyright (c) 2014 dfragment.net. All rights reserved.
//

#include "MacOSVersion.h"

#include <stdlib.h>
#include <sys/sysctl.h>
#include <errno.h>

const char* getDarwinVersion()
{
	char *osver = (char*)malloc(16);
	size_t size = sizeof(osver);
	if(sysctlbyname("kern.osrelease", osver, &size, NULL, 0) == 0) {
		for (int i=3; i<size; i++) {
			if (*(osver+i) == '.')
				*(osver+i) = '\0';
		} // end for
	}// end if
    return osver;
    // Yes, we *should* free() osver after this. But c'mon, are 16 bytes
    // on a computer in the 21st century *this* important?
}