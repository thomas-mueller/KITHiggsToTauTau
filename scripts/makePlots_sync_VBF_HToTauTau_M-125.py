#!/usr/bin/env python
# -*- coding: utf-8 -*-

import logging
import Artus.Utility.logger as logger
log = logging.getLogger(__name__)

import argparse
import shlex


if __name__ == "__main__":

	parser = argparse.ArgumentParser(description="Make VBF Htt 125 sync plots.",
	                                 parents=[logger.loggingParser])

	parser.add_argument("-i", "--input-1", nargs="*",
	                    default=["$CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/auxiliaries/SyncNtuples_KIT/SYNCFILE_VBF_HToTauTau_M-125_2012.root"],
	                    help="KIT input file. [Default: %(default)s]")
	parser.add_argument("--input-2-em",
	                    default="$CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/auxiliaries/SyncNtuples_IC/SYNCFILE_VBF_HToTauTau_M-125_em_2012.root",
	                    help="IC input file (EM channel). [Default: %(default)s]")
	parser.add_argument("--input-2-et",
	                    default="$CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/auxiliaries/SyncNtuples_IC/SYNCFILE_VBF_HToTauTau_M-125_et_2012.root",
	                    help="IC input file (ET channel). [Default: %(default)s]")
	parser.add_argument("--input-2-mt",
	                    default="$CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/auxiliaries/SyncNtuples_IC/SYNCFILE_VBF_HToTauTau_M-125_mt_2012.root",
	                    help="IC input file (MT channel). [Default: %(default)s]")
	parser.add_argument("--input-2-tt",
	                    default="$CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/auxiliaries/SyncNtuples_MIT/htt_vbf_tt_sm_125_select.root",
	                    help="MIT input file (MT channel). [Default: %(default)s]")
	parser.add_argument("--quantities", nargs="*",
	                    default=["1",
	                             "pt_1", "eta_1", "phi_1", "iso_1",
	                             "pt_2", "eta_2", "phi_2", "iso_2",
	                             "mvis",
	                             "met", "metphi", "metcov00", "metcov01", "metcov10", "metcov11",
	                             "mvamet", "mvametphi", "mvacov00", "mvacov01", "mvacov10", "mvacov11",
	                             "trigweight_1", "trigweight_2",
	                             "npv", "npu", "rho"],
	                    help="Quantities. [Default: %(default)s]")
	                    
	
	args = vars(parser.parse_args())
	logger.initLogger(args)

	channels = {
		"em" : "IC",
		"et" : "IC",
		"mt" : "IC",
		"tt" : "MIT",
	}
	
	folders = {
		"IC" : "TauCheck",
		"MIT" : "Events",
	}
	
	labels = {
		"eta" : False,
	}
	
	plot_commands = []
	for channel, label in channels.items():
		for quantity in args["quantities"]:
			plot_commands.append("higgsplot.py --plot-modules PlotRootHtt -f png pdf --labels KIT %s --ratio -i \"%s\" \"%s\" --folder %s/ntuple %s -o plots/VBF_HToTauTau_M-125/%s -x %s" % (label, " ".join(args["input_1"]), args["input_2_%s" % channel], channel, folders[channels[channel]], channel, quantity))
	
	for plot_command in plot_commands:
		log.info("\nMake plot \"%s\" ..." % plot_command)
		logger.subprocessCall(shlex.split(plot_command))

