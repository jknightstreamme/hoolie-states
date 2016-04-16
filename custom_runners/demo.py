'''
Runner for demo code
'''

from __future__ import absolute_import

import logging
import salt.runners.lambda_events
import salt.client


def __virtual__():
    return 'demo'


def giphyget(keyword):

    # get giphy
    ret = salt.runners.lambda_events.giphyget(keyword)

    # update web pages

    fun = 'state.sls'
    tgt = 'saltconf:True'
    expr_form = 'grain'

    args = ('updatewebpage')
    kwarg = {"pillar": ret}
    local = salt.client.get_local_client(__opts__['conf_file'])
    cmdret = local.cmd(tgt, expr_form, fun, args, kwarg)

    return True
