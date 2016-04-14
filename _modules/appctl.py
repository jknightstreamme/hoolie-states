# -*- coding: utf-8 -*-
'''
Module to help with application deployments

'''


from __future__ import absolute_import


# Import salt libs
import salt.utils

# Define the module's virtual name
__virtualname__ = 'appctl'


def __virtual__():
    return __virtualname__


def deploy(appname, newversion):

    ret = __salt__['state.sls'](
        mods='sites.{0}'.format(appname),
        pillar='{"version":"{0}"}'.format(newversion)
        )

    return ret