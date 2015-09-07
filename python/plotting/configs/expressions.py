
# -*- coding: utf-8 -*-

import logging
import Artus.Utility.logger as logger
log = logging.getLogger(__name__)

import Artus.HarryPlotter.utility.expressions as expressions


class ExpressionsDict(expressions.ExpressionsDict):
	def __init__(self, additional_expressions=None):
		super(ExpressionsDict, self).__init__(additional_expressions=additional_expressions)
		
		# category cuts
		self.expressions_dict["cat_inclusive"] = "1.0"
		self.expressions_dict["catZtt13TeV_inclusive"] = self.expressions_dict["cat_inclusive"]
		self.expressions_dict["catHtt13TeV_inclusive"] = self.expressions_dict["cat_inclusive"]
		for channel in ["tt", "mt", "et", "em", "mm", "ee"]:
			self.expressions_dict["catZtt13TeV_"+channel+"_inclusive"] = self.expressions_dict["catZtt13TeV_inclusive"]
			self.expressions_dict["catHtt13TeV_"+channel+"_inclusive"] = self.expressions_dict["catHtt13TeV_inclusive"]
		
		self.expressions_dict["cat_0jet"] = "njetspt20 < 1"
		self.expressions_dict["catZtt13TeV_0jet"] = self.expressions_dict["cat_0jet"]
		self.expressions_dict["catHtt13TeV_0jet"] = self.expressions_dict["cat_0jet"]
		for channel in ["tt", "mt", "et", "em", "mm", "ee"]:
			self.expressions_dict["catZtt13TeV_"+channel+"_0jet"] = self.expressions_dict["catZtt13TeV_0jet"]
			self.expressions_dict["catHtt13TeV_"+channel+"_0jet"] = self.expressions_dict["catHtt13TeV_0jet"]
		
		self.expressions_dict["cat_1jet"] = "(njetspt20 > 0)*(njetspt20 < 2)"
		self.expressions_dict["catZtt13TeV_1jet"] = self.expressions_dict["cat_1jet"]
		self.expressions_dict["catHtt13TeV_1jet"] = self.expressions_dict["cat_1jet"]
		for channel in ["tt", "mt", "et", "em", "mm", "ee"]:
			self.expressions_dict["catZtt13TeV_"+channel+"_1jet"] = self.expressions_dict["catZtt13TeV_1jet"]
			self.expressions_dict["catHtt13TeV_"+channel+"_1jet"] = self.expressions_dict["catHtt13TeV_1jet"]
		
		self.expressions_dict["cat_2jet"] = "njetspt20 > 1"
		self.expressions_dict["catZtt13TeV_2jet"] = self.expressions_dict["cat_2jet"]
		self.expressions_dict["catHtt13TeV_2jet"] = self.expressions_dict["cat_2jet"]
		for channel in ["tt", "mt", "et", "em", "mm", "ee"]:
			self.expressions_dict["catZtt13TeV_"+channel+"_2jet"] = self.expressions_dict["catZtt13TeV_2jet"]
			self.expressions_dict["catHtt13TeV_"+channel+"_2jet"] = self.expressions_dict["catHtt13TeV_2jet"]
			
		self.expressions_dict["cat_OneProngPiZeros"] = "(decayMode_2 > 0)*(decayMode_2 < 3)"
		self.expressions_dict["catOneProngPiZeros"] = self.expressions_dict["cat_OneProngPiZeros"]
		for channel in [ "mt", "et"]:
			self.expressions_dict["catOneProngPiZeros_"+channel] = self.expressions_dict["catOneProngPiZeros"]
		
		self.expressions_dict["cat_ThreeProng"] = "(decayMode_2 > 9)*(decayMode_2 < 11)"
		self.expressions_dict["catThreeProng"] =self.expressions_dict["cat_ThreeProng"]
		for channel in [ "mt", "et"]:
			self.expressions_dict["catThreeProng_"+channel] = self.expressions_dict["catThreeProng"]		
		
		replacements = {
			"0jet" : "zerojet",
			"1jet" : "onejet",
			"2jet" : "twojet",
		}
		for short_expression, long_expression in self.expressions_dict.items():
			if any([replacement in short_expression for replacement in replacements.keys()]):
				new_short_expression = short_expression
				for replacement in replacements.iteritems():
					new_short_expression = new_short_expression.replace(*replacement)
				self.expressions_dict[new_short_expression] = long_expression

