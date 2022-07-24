/**
 * Original code by aimozg on 27.01.14.
 * Extended for Mutations by Jtecx on 14.03.22.
 */
package classes.IMutations
{
import classes.PerkClass;
import classes.IMutationPerkType;
import classes.Creature;
import classes.Player;
import classes.Races;
import classes.Scenes.NPCs.LunaFollower;

public class AlphaHowlMutation extends IMutationPerkType
    {
        private static const mName:String = "Alpha Howl";
        //v1 contains the mutation tier
        override public function mDesc(params:PerkClass, pTier:int = -1):String {
            var descS:String = "";
            pTier = (pTier == -1)? currentTier(this, player): pTier;
            if (pTier >= 1){
                descS += "You may now form a pack. Unlock the pack attack Feral attack. ";
            }
            if (pTier >= 2){
                descS += "Each additional pack member assists in your defense increasing damage reduction by 2%. ";
            }
            if (pTier >= 3){
                descS += "Each additional pack member helps coordinate your offense, increasing your feral damage by 2% per member. ";
            }
            if (pTier >= 4){
                descS += "Raise the bonus from Evolved to 5% and grants an while a canine increase to all stat of 5% per pack member. ";
            }
            descS += "You may have up to " + 5 * pTier + " pack members";
            if (descS != "")descS += ".";
            return descS;
        }

        //Name. Need it say more?
        override public function name(params:PerkClass=null):String {
            var sufval:String;
            switch (currentTier(this, player)){
                case 2:
                    sufval = "(Primitive)";
                    break;
                case 3:
                    sufval = "(Evolved)";
                    break;
                case 4:
                    sufval = "(Final Form)";
                    break;
                default:
                    sufval = "";
            }
            return mName + sufval;
        }

        //Mutation Requirements
        override public function pReqs():void{
            try{
                var pTier:int = currentTier(this, player);
                //This helps keep the requirements output clean.
                this.requirements = [];
                if (pTier == 0){
                    this.requireAdaptationsMutationSlot()
                    .requireCustomFunction(function (player:Player):Boolean {
                        return player.isRace(Races.WEREWOLF,1);
                    }, "Werewolf race");
                }
                else{
                    var pLvl:int = pTier * 30;
                    this.requireLevel(pLvl);
                }
            }catch(e:Error){
                trace(e.getStackTrace());
            }
        }

        //Mutations Buffs
        override public function pBuffs(target:Creature = null):Object{
            var pBuffs:Object = {};
            var pTier:int = currentTier(this, (target == null)? player : target);
            if (pTier == 1) pBuffs['str.mult'] = 0.05;
            else if (pTier == 2) pBuffs['str.mult'] = 0.15;
            else if (pTier == 3) pBuffs['str.mult'] = 0.30;
            else if (pTier == 4) pBuffs['str.mult'] = 0.45;
            if (pTier == 4 && (player.isRaceCached(Races.WEREWOLF) || player.isRaceCached(Races.DOG) || player.isRaceCached(Races.WOLF))){
                pBuffs['str.mult'] += 0.05*LunaFollower.WerewolfPackMember;
                pBuffs['spe.mult'] += 0.05*LunaFollower.WerewolfPackMember;
                pBuffs['tou.mult'] += 0.05*LunaFollower.WerewolfPackMember;
                pBuffs['int.mult'] += 0.05*LunaFollower.WerewolfPackMember;
                pBuffs['wis.mult'] += 0.05*LunaFollower.WerewolfPackMember;
                pBuffs['lib.mult'] += 0.05*LunaFollower.WerewolfPackMember;
            }
            return pBuffs
        }

        public function AlphaHowlMutation() {
            super(mName + " IM", mName, SLOT_LUNGS, 4);
        }
        
    }
}