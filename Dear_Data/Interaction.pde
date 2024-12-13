boolean TimesDied = false;
boolean TimesSlept = false;
boolean CreeperExplosion = false;
boolean MobsKilled = false;
boolean OtherPlayers = false;

void weekInteraction() {
  if (key == 'd') {
    TimesDied = ! TimesDied;
  }

  if (key == 's') {
    TimesSlept = ! TimesSlept;
  }

  if (key == 'c') {
    CreeperExplosion = ! CreeperExplosion;
  }

  if (key == 'k') {
    MobsKilled = ! MobsKilled;
  }
  
  if (key == 'o'){
    OtherPlayers = ! OtherPlayers;
  }
}
