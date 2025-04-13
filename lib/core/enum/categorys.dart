import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Categorys {
  food(
    name: 'Ăn uống',
    icon: FontAwesomeIcons.utensils,
    backgroundColorIcon: Colors.red,
    note: 'Chi phí cho ăn uống hàng ngày',
  ),
  transport(
    name: 'Di chuyển',
    icon: FontAwesomeIcons.bus,
    backgroundColorIcon: Colors.blue,
    note: 'Đi lại, xăng xe, phương tiện công cộng',
  ),
  others(
    name: 'Khác',
    icon: FontAwesomeIcons.ellipsis,
    backgroundColorIcon: Colors.yellow,
    note: "Vui lòng thêm 1 cái khác",
  ),
/*  shopping(
    name: 'Mua sắm',
    icon: FontAwesomeIcons.cartShopping,
    backgroundColorIcon: Colors.green,
    note: 'Mua đồ dùng cá nhân hoặc gia đình',
  ),
  others(
    name: 'Khác',
    icon: FontAwesomeIcons.ellipsis,
    backgroundColorIcon: Colors.yellow,
    note: null,
  ),s
  personal(
    name: 'Cá nhân',
    icon: FontAwesomeIcons.user,
    backgroundColorIcon: Colors.purple,
    note: 'Chi phí cho các nhu cầu cá nhân',
  ),
  online(
    name: 'Trực tuyến',
    icon: FontAwesomeIcons.laptop,
    backgroundColorIcon: Colors.orange,
    note: 'Chi tiêu cho dịch vụ online, mua hàng online',
  ),
  entertainment(
    name: 'Giải trí',
    icon: FontAwesomeIcons.film,
    backgroundColorIcon: Colors.cyan,
    note: 'Xem phim, ca nhạc, vui chơi',
  ),
  travel(
    name: 'Du lịch',
    icon: FontAwesomeIcons.plane,
    backgroundColorIcon: Colors.teal,
    note: 'Chi phí đi du lịch, nghỉ dưỡng',
  ),
  investment(
    name: 'Đầu tư',
    icon: FontAwesomeIcons.chartBar,
    backgroundColorIcon: Colors.pink,
    note: 'Đầu tư tài chính, chứng khoán',
  ),
  payment(
    name: 'Thanh toán',
    icon: FontAwesomeIcons.creditCard,
    backgroundColorIcon: Colors.brown,
    note: null,
  ),
  quick(
    name: 'Nhanh',
    icon: FontAwesomeIcons.bolt,
    backgroundColorIcon: Colors.indigo,
    note: 'Chi tiêu khẩn cấp, nhanh chóng',
  ),
  bills(
    name: 'Hóa đơn',
    icon: FontAwesomeIcons.receipt,
    backgroundColorIcon: Colors.amber,
    note: 'Thanh toán hóa đơn điện, nước, mạng',
  ),
  vehicle(
    name: 'Phương tiện',
    icon: FontAwesomeIcons.car,
    backgroundColorIcon: Colors.deepPurple,
    note: 'Mua bán, sửa chữa phương tiện',
  ),
  xchange(
    name: 'Trao đổi',
    icon: FontAwesomeIcons.rightLeft,
    backgroundColorIcon: Colors.lightGreen,
    note: null,
  ),
  withdraw(
    name: 'Rút tiền',
    icon: FontAwesomeIcons.moneyBill1,
    backgroundColorIcon: Colors.deepOrange,
    note: 'Rút tiền mặt từ ngân hàng hoặc ATM',
  ),
  transfer(
    name: 'Chuyển tiền',
    icon: FontAwesomeIcons.rightLeft,
    backgroundColorIcon: Colors.lightBlue,
    note: 'Chuyển khoản cho người khác',
  ),
  fees(
    name: 'Phí',
    icon: FontAwesomeIcons.moneyBill,
    backgroundColorIcon: Colors.blueGrey,
    note: 'Các loại phí dịch vụ',
  ),
  apparel(
    name: 'Quần áo',
    icon: FontAwesomeIcons.shirt,
    backgroundColorIcon: Colors.redAccent,
    note: 'Mua sắm quần áo, giày dép',
  ),
  beauty(
    name: 'Làm đẹp',
    icon: FontAwesomeIcons.faceSmile,
    backgroundColorIcon: Colors.greenAccent,
    note: 'Chăm sóc sắc đẹp, spa',
  ),
  education(
    name: 'Giáo dục',
    icon: FontAwesomeIcons.graduationCap,
    backgroundColorIcon: Colors.yellowAccent,
    note: 'Học phí, sách vở, khóa học',
  ),
  health(
    name: 'Sức khỏe',
    icon: FontAwesomeIcons.heartPulse,
    backgroundColorIcon: Colors.purpleAccent,
    note: 'Khám bệnh, thuốc thang',
  ),
  home(
    name: 'Nhà cửa',
    icon: FontAwesomeIcons.house,
    backgroundColorIcon: Colors.orangeAccent,
    note: 'Thuê nhà, sửa nhà',
  ),
  technology(
    name: 'Công nghệ',
    icon: FontAwesomeIcons.laptopCode,
    backgroundColorIcon: Colors.cyanAccent,
    note: 'Mua đồ công nghệ, phần mềm',
  ),
  work(
    name: 'Công việc',
    icon: FontAwesomeIcons.briefcase,
    backgroundColorIcon: Colors.tealAccent,
    note: 'Chi phí liên quan đến công việc',
  ),
  gifts(
    name: 'Quà tặng',
    icon: FontAwesomeIcons.gift,
    backgroundColorIcon: Colors.pinkAccent,
    note: 'Mua quà cho người thân, bạn bè',
  ),
  sports(
    name: 'Thể thao',
    icon: FontAwesomeIcons.football,
    backgroundColorIcon: Colors.brown,
    note: 'Dụng cụ thể thao, sân bãi',
  ),
  music(
    name: 'Âm nhạc',
    icon: FontAwesomeIcons.music,
    backgroundColorIcon: Colors.indigoAccent,
    note: 'Mua nhạc, nhạc cụ',
  ),
  books(
    name: 'Sách',
    icon: FontAwesomeIcons.book,
    backgroundColorIcon: Colors.amberAccent,
    note: 'Mua sách đọc',
  ),
  pets(
    name: 'Thú cưng',
    icon: FontAwesomeIcons.paw,
    backgroundColorIcon: Colors.deepPurpleAccent,
    note: 'Chăm sóc thú cưng',
  ),
  social(
    name: 'Xã hội',
    icon: FontAwesomeIcons.users,
    backgroundColorIcon: Colors.lightGreenAccent,
    note: null,
  ),
  events(
    name: 'Sự kiện',
    icon: FontAwesomeIcons.calendarDays,
    backgroundColorIcon: Colors.deepOrangeAccent,
    note: 'Tham gia sự kiện, hội thảo',
  ),
  party(
    name: 'Tiệc tùng',
    icon: FontAwesomeIcons.cakeCandles,
    backgroundColorIcon: Colors.lightBlueAccent,
    note: 'Tiệc sinh nhật, liên hoan',
  ),
  baby(
    name: 'Em bé',
    icon: FontAwesomeIcons.baby,
    backgroundColorIcon: Colors.blueGrey,
    note: 'Mua đồ cho em bé',
  ),
  fitness(
    name: 'Thể hình',
    icon: FontAwesomeIcons.dumbbell,
    backgroundColorIcon: Colors.redAccent,
    note: 'Phòng gym, thể hình',
  ),
  gardening(
    name: 'Làm vườn',
    icon: FontAwesomeIcons.seedling,
    backgroundColorIcon: Colors.greenAccent,
    note: 'Mua cây trồng, vật tư làm vườn',
  ),
  art(
    name: 'Nghệ thuật',
    icon: FontAwesomeIcons.palette,
    backgroundColorIcon: Colors.yellowAccent,
    note: 'Hội họa, mỹ thuật',
  ),
  finance(
    name: 'Tài chính',
    icon: FontAwesomeIcons.chartPie,
    backgroundColorIcon: Colors.purpleAccent,
    note: 'Kế hoạch tài chính cá nhân',
  ),
  photography(
    name: 'Nhiếp ảnh',
    icon: FontAwesomeIcons.camera,
    backgroundColorIcon: Colors.orangeAccent,
    note: 'Thiết bị và dịch vụ chụp ảnh',
  ),
  gaming(
    name: 'Game',
    icon: FontAwesomeIcons.gamepad,
    backgroundColorIcon: Colors.cyanAccent,
    note: 'Mua game, đồ chơi game',
  );*/
  ;

  final String name;
  final IconData icon;
  final Color backgroundColorIcon;
  final String? note; // <- thêm note nullable vào đây

  const Categorys({
    required this.name,
    required this.icon,
    required this.backgroundColorIcon,
    this.note, // <- cho phép note null
  });

  static Categorys fromIndex(int categoryIndex) {
    return Categorys.values.firstWhere(
      (category) => category.index == categoryIndex,
      orElse: () => Categorys.others,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon.codePoint,
      'backgroundColorIcon': backgroundColorIcon.toARGB32(),
      'note': note,
    };
  }

  factory Categorys.fromMap(Map<String, dynamic> map) {
    return Categorys.values.firstWhere(
      (category) => category.name == map['name'],
      orElse: () => Categorys.others,
    );
  }
}

const List<Categorys> categorys = Categorys.values;
