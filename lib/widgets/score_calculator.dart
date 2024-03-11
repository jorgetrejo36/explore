// this needs to be made official

int calculateScore(int currency, int timer) {
  int score = currency * 100;
  int reductionStart = 30;
  int reductionEnd = 360;

  if (timer > reductionEnd) {
    // Reduce by max points
    score = score - reductionEnd;
  } else if (timer < reductionStart) {
    // Do nothing, perect score
  } else {
    // Reduce score by time between min and overall
    timer = timer - reductionStart;
    score = score - timer;
  }
  return score;
}
