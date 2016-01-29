
#pragma once

#include "Kappa/DataFormats/interface/Kappa.h"
#include "Artus/Utility/interface/SafeMap.h"

/**
   \brief Place to collect functions of general use
*/
	


class GeneratorInfo {

public:
	enum class GenMatchingCode : int
	{
		isElePrompt   = 1,
		isMuonPrompt  = 2,
		isEleFromTau  = 3,
		isMuonFromTau = 4,
		isTauHadDecay = 5,
		isFake        = 6
	};
	
	static int GetGenMatchingCode(const KGenParticle* genParticle);
	static const KGenParticle* GetGenMatchedParticle(KLepton* lepton,
							 const std::map<KLepton*, const KGenParticle*> leptonGenParticleMap,
							 const std::map<KTau*, KGenTau*> tauGenTauMap);

private:
	GeneratorInfo() {  };
};
