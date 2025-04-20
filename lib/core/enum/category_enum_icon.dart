import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum CategoryIcons {
  shopping(FontAwesomeIcons.cartShopping),
  personal(FontAwesomeIcons.user),
  online(FontAwesomeIcons.laptop),
  entertainment(FontAwesomeIcons.film),
  travel(FontAwesomeIcons.plane),
  investment(FontAwesomeIcons.chartBar),
  payment(FontAwesomeIcons.creditCard),
  quick(FontAwesomeIcons.bolt),
  bills(FontAwesomeIcons.receipt),
  vehicle(FontAwesomeIcons.car),
  xchange(FontAwesomeIcons.rightLeft),
  withdraw(FontAwesomeIcons.moneyBill1),
  transfer(FontAwesomeIcons.rightLeft),
  fees(FontAwesomeIcons.moneyBill),
  apparel(FontAwesomeIcons.shirt),
  beauty(FontAwesomeIcons.faceSmile),
  education(FontAwesomeIcons.graduationCap),
  health(FontAwesomeIcons.heartPulse),
  home(FontAwesomeIcons.house),
  technology(FontAwesomeIcons.laptopCode),
  work(FontAwesomeIcons.briefcase),
  gifts(FontAwesomeIcons.gift),
  sports(FontAwesomeIcons.football),
  music(FontAwesomeIcons.music),
  books(FontAwesomeIcons.book),
  pets(FontAwesomeIcons.paw),
  social(FontAwesomeIcons.users),
  events(FontAwesomeIcons.calendarDays),
  party(FontAwesomeIcons.cakeCandles),
  baby(FontAwesomeIcons.baby),
  fitness(FontAwesomeIcons.dumbbell),
  gardening(FontAwesomeIcons.seedling),
  art(FontAwesomeIcons.palette),
  finance(FontAwesomeIcons.chartPie),
  photography(FontAwesomeIcons.camera),
  gaming(FontAwesomeIcons.gamepad),
  food(FontAwesomeIcons.utensils),
  transport(FontAwesomeIcons.bus),
  others(FontAwesomeIcons.ellipsis);

  final IconData icon;
  const CategoryIcons(this.icon);
}
