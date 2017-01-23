#!/usr/bin/env python
# -*- coding: utf-8 -*-

import logging
import Artus.Utility.logger as logger
log = logging.getLogger(__name__)

import argparse
import copy
import os

import Artus.Utility.jsonTools as jsonTools

import HiggsAnalysis.KITHiggsToTauTau.plotting.higgsplot as higgsplot

import sys

if __name__ == "__main__":

	parser = argparse.ArgumentParser(description="Make CP plots.",
	                                 parents=[logger.loggingParser])

	parser.add_argument("-i", "--input", required=True, nargs="*",
	                    help="Input.")
	parser.add_argument("-a", "--args", default="--plot-modules PlotRootHtt",
	                    help="Additional Arguments for HarryPlotter. [Default: %(default)s]")
	parser.add_argument("-n", "--n-processes", type=int, default=1,
	                    help="Number of (parallel) processes. [Default: %(default)s]")
	parser.add_argument("-f", "--n-plots", type=int,
	                    help="Number of plots. [Default: all]")
	parser.add_argument("-o", "--output-dir",
	                    default="$CMSSW_BASE/src/plots/control_plots/",
	                    help="Output directory. [Default: %(default)s]")

	args = parser.parse_args()
	logger.initLogger(args)
	names=args.input
	#CutEff PLOT
	plot_configs = []
		
	config_CutEff = {
    	"analysis_modules": [
		"CutEfficiency"
    	], 
    	"cut_efficiency_bkg_nicks": [
		"H+tt",
		"H+et",
		"H+mt"
    	], 
    	"cut_efficiency_nicks": [
    		"roc_tt",
		"roc_et",
		"roc_mt"
    	], 
    	"cut_efficiency_sig_nicks": [
		"H-tt",
		"H-et",
		"H-mt"
    	], 
    	"filename": "ROC_all", 
	"files": ["tmvaClassification/BDT_tt.root","tmvaClassification/BDT_tt.root", "tmvaClassification/BDT_et.root","tmvaClassification/BDT_et.root", "tmvaClassification/BDT_mt.root","tmvaClassification/BDT_mt.root"],
    	"folders": [
		"TrainTree"
    	], 
    	"markers": [
		"LP"
    	], 
    	"nicks": [
		"H-tt",
		"H+tt",
		"H-et",
		"H+et",
		"H-mt",
		"H+mt"
	], 
    	"nicks_whitelist": [
		"roc_tt",
		"roc_et",
		"roc_mt"
    	], 
    	"weights": [
		"classID<0.5", 
		"classID>0.5"
    	], 
    	 
    	"x_expressions": [
		"BDT"
    	], 
    	"x_label": "bkg_rej", 
    	"y_label": "sig_eff"
	}

	plot_configs.append(config_CutEff)
	
	# BDT PLOT
	
	for i in range(len(names)):
		config_BDT = {
	    	"analysis_modules": [
			"NormalizeToUnity"
	    	], 
	    	"colors": [
			"1", 
			"2", 
			"1", 
			"2"
	    	], 
	    	"filename": "BDT_"+names[i], 
		"files": "tmvaClassification/BDT_"+names[i]+".root",
	    	"folders": [
			"TrainTree", 
			"TrainTree", 
			"TestTree", 
			"TestTree"
	    	], 
	    	"markers": [
			"LINE", 
			"LINE", 
			"E", 
			"E"
	    	], 
	    	"weights": [
			"classID<0.5", 
			"classID>0.5", 
			"classID<0.5", 
			"classID>0.5"
	    	], 
	       	"x_expressions": [
	    	    "BDT"
		]	
		}
		plot_configs.append(config_BDT)
	
	if log.isEnabledFor(logging.DEBUG):
		import pprint
		pprint.pprint(plot_configs)
	
	higgsplot.HiggsPlotter(list_of_config_dicts=plot_configs, list_of_args_strings=[args.args], n_processes=args.n_processes, n_plots=args.n_plots)
