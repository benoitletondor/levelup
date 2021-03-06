/*
 *   Copyright 2015 Benoit LETONDOR
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

part of levelup;

class MathHelper {
  static num degreeToRadian(num degree) => degree * math.PI / 180;

  static num radianToDegree(num radian) => radian * 180 / math.PI;

  static num radianAngleBetween2Objects(
      math.Point destination, math.Point origin) {
    return (math.PI / 2) + math.atan2(destination.y - origin.y, destination.x - origin.x);
  }

  static num degreeAngleBetween2Objects(
      math.Point mouse, math.Point object) {
    num angle = radianToDegree(radianAngleBetween2Objects(mouse, object));

    if (angle < 0) {
      angle = 360 - (-angle);
    }

    return angle;
  }
}
