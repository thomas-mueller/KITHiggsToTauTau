#!/usr/bin/env python
# -*- coding: utf-8 -*-

import logging
import Artus.Utility.logger as logger
log = logging.getLogger(__name__)

import re
import json
import Artus.Utility.jsonTools as jsonTools
#import Kappa.Skimming.datasetsHelperTwopz as datasetsHelperTwopz

def build_list():
  quantities_list = [
    "ggh_t_weight",
    "ggh_b_weight",
    "ggh_i_weight",
    "ggH_t_weight",
    "ggH_b_weight",
    "ggH_i_weight",
    "ggA_t_weight",
    "ggA_b_weight",
    "ggA_i_weight"
	]
  
  return quantities_list