float distance_between_two_points(float _x1, float _x2, float _y1, float _y2) {
  float result = sqrt(pow((_x1-_x2), 2) + pow((_y1-_y2), 2));  
  return result;
}

float calcMoveTheta(float targetX, float targetY, float objectX, float objectY) {
  float hypotenuse = distance_between_two_points(objectX, targetX, objectY, targetY);
  float _thetaRad = asin(abs(targetY - objectY) / hypotenuse);
  //println("Raw CALC theta " + degrees(_thetaRad));
  float detX = targetX - objectX;
  float detY = targetY - objectY;
  _thetaRad = returnRealTheta(_thetaRad, detX, detY);
  return _thetaRad;
}

float returnRealTheta(float __theta, float determinantX, float determinantY) {
  if (determinantX >= 0 && determinantY < 0) {
    __theta = __theta;
  } else if (determinantX < 0 && determinantY < 0) {
    __theta = PI - __theta;
  } else if (determinantX < 0 && determinantY >= 0) {
    __theta = PI + __theta;
  } else if (determinantX >= 0 && determinantY >= 0) {
    __theta = TWO_PI - __theta;
  } else println("wtf?");

  return __theta;
}