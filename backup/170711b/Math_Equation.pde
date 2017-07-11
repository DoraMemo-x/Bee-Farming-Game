float distance_between_two_points(float _x1, float _x2, float _y1, float _y2) {
  float result = sqrt(pow((_x1-_x2), 2) + pow((_y1-_y2), 2));  
  return result;
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
