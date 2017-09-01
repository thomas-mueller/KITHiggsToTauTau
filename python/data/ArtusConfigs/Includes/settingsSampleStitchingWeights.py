#!/usr/bin/env python
# -*- coding: utf-8 -*-

import logging
import Artus.Utility.logger as logger
log = logging.getLogger(__name__)

import re
import json
import copy
import Artus.Utility.jsonTools as jsonTools
#import Kappa.Skimming.datasetsHelperTwopz as datasetsHelperTwopz
import importlib
#import os

def build_config(nickname):
  config = jsonTools.JsonDict()
  #datasetsHelper = datasetsHelperTwopz.datasetsHelperTwopz(os.path.expandvars("$CMSSW_BASE/src/Kappa/Skimming/data/datasets.json"))
  
  
  ## fill config:
  # includes
  includes = [
    ]
  for include_file in includes:
    analysis_config_module = importlib.import_module(include_file)
    config += analysis_config_module.build_config(nickname)
  
  # explicit configuration
  StitchingWeights = {
    "DY.?JetsToLLM(50|150)_RunIIFall15" : [
      "0:2.43669e-5",
      "1:1.06292e-5",
      "2:1.10505e-5",
      "3:1.14799e-5",
      "4:9.62135e-6"
    ],
    "DY.?JetsToLLM(50|150)_RunIISpring16" : [
      "0:1.15592037377927e-4",
      "1:1.5569730365567e-5",
      "2:1.6806948607887e-5",
      "3:1.7471761634154e-5",
      "4:1.3697397756176e-5"
    ],
    "DY.?JetsToLLM(50|150)_RunIISummer16" : [
      "0:1.17315803668195e-4",
      "1:1.621414441741e-5",
      "2:1.6643877999447e-5",
      "3:1.7249743875469e-5",
      "4:1.3442049896748e-5"
    ],
    "W.?JetsToLNu_RunIIFall15" : [
      "0:1.3046006677e-3",
      "1:2.162338159e-4",
      "2:1.159006627e-4",
      "3:5.82002641e-5",
      "4:6.27558901e-5"
    ],
    "W.?JetsToLNu_RunIISpring16" : [
      "0:2.1809966268e-3",
      "1:2.602609942e-4",
      "2:1.209708431e-4",
      "3:5.71488637e-5",
      "4:6.27792554e-5"
    ],
    "W.?JetsToLNu_RunIISummer16" : [
      "0:7.09390278348407e-4",
      "1:1.90063898596475e-4",
      "2:5.8529964471165e-5",
      "3:1.9206444928444e-5",
      "4:1.923548021385e-5"
    ]
  }
  for key, val in StitchingWeights.items():
    if re.search(key, nickname): config["StitchingWeights"] = val
  
  StitchingWeightsHighMass = {
    "DY.?JetsToLLM(50|150)_RunIIFall15" : [
      "0:1.26276e-6",
      "1:1.18349e-6",
      "2:1.18854e-6",
      "3:1.19334e-6",
      "4:1.16985e-6"
    ],
    "DY.?JetsToLLM(50|150)_RunIISpring16" : [
      "0:1.254491241721e-6",
      "1:1.17272893569e-6",
      "2:1.179267559383e-6",
      "3:1.182424451247e-6",
      "4:1.160777761878e-6"
    ]
  }
  for key, val in StitchingWeightsHighMass.items():
    if re.search(key, nickname): config["StitchingWeightsHighMass"] = val

  

  return config