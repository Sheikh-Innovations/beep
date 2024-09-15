import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

//To Define If call is Audio Or Video
enum CallType { video, phone }

//To Define If call is coming or outgoing to show arrow
enum ArrowDirection { incoming, outgoing }

//Is it One Person Call or Group Call
enum UserType { person, group }

// ---> Custom Log Tile Design <--- //
class CustomLogsTile extends StatelessWidget {
  final UserType userType; // Option for person or group
  final CallType callType; // Option for phone call or video call
  final ArrowDirection arrowDirection; // Option for incoming or outgoing
  final String userName; // Dynamic user name
  final String? avatarPath; // Optional avatar path for person
  final String date; // Dynamic date value
  final String time; // Dynamic time value

  const CustomLogsTile({
    super.key,
    required this.userType,
    required this.callType,
    required this.arrowDirection,
    required this.userName, // Required dynamic user name
    this.avatarPath, // Optional avatar path (for person only)
    required this.date, // Required dynamic date
    required this.time, // Required dynamic time
  });

  @override
  Widget build(BuildContext context) {
    // Size of screen width and avatar size according to responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarSize = screenWidth * 0.125; // Responsiveness for avatar size

    // Choose image based on user type (person or group)
    Widget userImage = userType == UserType.person
        ? Image.asset(avatarPath ??
                'assets/user_avatar.png') // Optional avatar path, with a default fallback
            .box
            .roundedFull
            .size(avatarSize, avatarSize)
            .color(Colors.green)
            .make()

        ///Group Call Avatar
        : Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/group_call_bg.svg',
                width: avatarSize,
                height: avatarSize,
              )
                  .box
                  .roundedFull
                  .color(const Color.fromARGB(
                      255, 242, 244, 246)) // Background color
                  .make(),
              SvgPicture.asset(
                'assets/mdi_people.svg',
              ).box.roundedFull.make(),
            ],
          );

    // Trailing icon (phone or video)
    Widget trailingIcon = callType == CallType.video
        ? SvgPicture.asset('assets/video_icon.svg').box.size(25, 25).make()
        : SvgPicture.asset('assets/phone_icon.svg').box.size(25, 25).make();

    // Arrow icon and color (red for incoming, green for outgoing)
    IconData arrowIcon = arrowDirection == ArrowDirection.incoming
        ? Icons.call_received_rounded // For incoming
        : Icons.call_made_rounded; // For outgoing

    Color arrowColor = arrowDirection == ArrowDirection.incoming
        ? Colors.red // Incoming arrows are red
        : Colors.green; // Outgoing arrows are green

    /// --- > List Tile Design <--- ///
    return ListTile(
      leading: userImage,
      trailing: trailingIcon,
      title: userName
          .text // Dynamic user name
          .semiBold
          .size(16)
          .fontWeight(FontWeight.w500)
          .color(GRAY_COLOR)
          .make(),
      subtitle: Row(
        children: [
          Icon(
            arrowIcon, // Dynamic arrow icon for Incoming and Outgoing call indication
            color: arrowColor,
            size: 20,
          ),
          const SizedBox(width: 8), // Spacing between the icon and text
          date.text // Dynamic date
              .size(14)
              .fontWeight(FontWeight.w500)
              .color(GRAY_COLOR)
              .make(),
          const SizedBox(width: 4),
          time.text // Dynamic time
              .size(14)
              .fontWeight(FontWeight.w500)
              .color(GRAY_COLOR)
              .make(),
        ],
      ),
    );
  }
}

//Gray Color of Text
const Color GRAY_COLOR = Color(0xFF6B7C85);



///----> Example of How to call this calllogstile in UI  <---- ////
            // CustomLogsTile( /// This is the call is grom group
            //   userType: UserType.group, // Group
            //   callType: CallType.video, // Video call
            //   arrowDirection: ArrowDirection.incoming, // Incoming call
            //   userName: "Work Zone", // Name of the group
            //   date: "2 Aug", // Date of the call
            //   time: "11:40 am", // Time of the call
            // ),


            
            // CustomLogsTile( /// This is the call is from person
            //   userType: UserType.person, // Person
            //   callType: CallType.phone, // Phone call
            //   arrowDirection: ArrowDirection.outgoing, // Outgoing call
            //   userName: "User Ali", // Name of the person
            //   avatarPath: 'assets/user_avatar.png', // Avatar image path
            //   date: "2 Aug", // Date of the call
            //   time: "11:40 am", // Time of the call
            // ),