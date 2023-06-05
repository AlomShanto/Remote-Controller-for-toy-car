import 'dart:math';

import 'package:flutter/cupertino.dart';

class Calculate{
    static int speed=0,maxSpeed=255,minSpeed=0;

    static int increase_speed() {
        speed+=30;
        speed=min(speed,maxSpeed);
        return speed;
    }

    static int decrease_speed(){
        speed-=30;
        speed=max(speed,minSpeed);
        return speed;
    }

    static int force_stop(int x){
        speed-=x;
        speed=max(speed,minSpeed);
        return speed;
    }


}