// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ICO_Phases {
    enum Phase { Seed, Private, Public }
    Phase public currentPhase;

    uint256 public phaseStartTime;
    uint256 public seedPhaseDuration = 7 days;
    uint256 public privatePhaseDuration = 14 days;
    uint256 public publicPhaseDuration = 21 days;

    function startSeedPhase() internal {
        currentPhase = Phase.Seed;
        phaseStartTime = block.timestamp;
    }

    function startPrivatePhase() internal {
        currentPhase = Phase.Private;
        phaseStartTime = block.timestamp;
    }

    function startPublicPhase() internal {
        currentPhase = Phase.Public;
        phaseStartTime = block.timestamp;
    }

    function getCurrentPhase() public view returns (Phase) {
        if (currentPhase == Phase.Seed && block.timestamp >= phaseStartTime + seedPhaseDuration) {
            return Phase.Private;
        } else if (currentPhase == Phase.Private && block.timestamp >= phaseStartTime + privatePhaseDuration) {
            return Phase.Public;
        } else {
            return currentPhase;
        }
    }
}
