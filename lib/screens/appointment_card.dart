import 'package:afyaexpress/screens/index.dart';
import 'package:afyaexpress/utils/config.dart';
import 'package:flutter/material.dart';


class AppointmentCard extends StatefulWidget {
  const AppointmentCard ({Key? key}) :super(key: key);

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: IndexPage.primaryBlue,
        borderRadius: BorderRadius.circular(10),

      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const  EdgeInsets.all(20),
          child: Column(
            children:<Widget> [
              Row(

                children: [
                  const  CircleAvatar(
                    backgroundImage: AssetImage('images/doc.png'), //doctor image to be inserted here

                  ),
                  const SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Dr. Sylvia Onyango',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 2,

                      ),
                      Text('Cardiologist',
                        style: TextStyle(color: Colors.black),)

                    ],
                  ),
                ],
              ),
              Config.spaceSmall,
//I will add schedule info here
 const ScheduleCard(),

              Config.spaceSmall,

              //action button code sync this with the database....

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: IndexPage.primaryDanger,
                        ),
                        child: const Text('Cancel',
                          style: TextStyle(color: Colors.white),


                        ),
                        onPressed: () {}, //cancel appointment logic goes here
                      ),
                  ),
                  const SizedBox(width: 20,),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: IndexPage.primaryDark,
                      ),
                      child: const Text('Completed',
                        style: TextStyle(color: Colors.white),


                      ),
                      onPressed: () {},  //appointment logics goes here
                    ),
                  ),
                ],
              )
            ],
          )

          ),
        ),
      );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard ({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: IndexPage.primaryMuted,
            borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const  <Widget>[
          Icon(Icons.calendar_today,
          color: Colors.white,
          size: 15,
          ),
           SizedBox(width: 5,),
          Text('Monday, 07/01/2024',
          style: const TextStyle(color: Colors.white,
          ),
          ),

           SizedBox(width: 20,),
           Icon(Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
           SizedBox(width: 5,),
          Flexible(child:
          Text('00:26 AM',
          style: TextStyle(color: Colors.white),
          ),
          ),
        ],
      ),
    );
  }
}

