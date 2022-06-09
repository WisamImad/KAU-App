import 'package:flutter/material.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:kau_app/utils/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: myBackground,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: myBackground,
          iconTheme: IconThemeData(
            color: myBink, //change your color here
          ),
        ),
        body: SafeArea(
          child: Container(
            color: myBackground,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Image(
                        image: AssetImage('assets/loglo.png'),
                        width: MediaQuery.of(context).size.width / 1.7,
                      ),
                      Text(
                        'عن التطبيق',
                        style: TextStyle(
                            fontFamily: fontHiding1,
                            color: myBlue,
                            fontSize: 36),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'الإبن الرضي هو تطبيق يهدف الى تنمية قيمة بر الوالدين لدى الأطفال عن طريق التعلم باللعب واستخدام التقنية كأداة مُساعدة للتربية بحيث تكون متاحة بيد الآباء و الأمهات لتشجيع أبنائهم على التخلق بهذه القيمة.',
                        style: TextStyle(
                            fontFamily: fontHiding2,
                            color: Colors.grey[800],
                            fontSize: 20),
                      ),
                      Text(
                        'مميزات التطبيق',
                        style: TextStyle(
                            fontFamily: fontHiding1,
                            color: myBlue,
                            fontSize: 36),
                      ),
                      Text(
                        """
                        الإبن الرضي
هو تطبيق يهدف الى تنمية قيمة بر الوالدين لدى الأطفال عن طريق التعلم باللعب واستخدام التقنية كأداة مُساعدة للتربية بحيث تكون متاحة بيد الآباء والأمهات لتشجيع أبنائهم على التخلق بهذه القيمة.

مميزات التطبيق
يحتوي التطبيق على واجهتين الإباء والابناء:
مميزات واجهة الإباء: يُمكن التطبيق الوالدين من التفاعل مع أطفالهم من خلال واجهة خاصة للوالدين وذلك بإرسال الملصقات أو المكافئات أو تنظيم جدول المهام، كما يرسل التطبيق نصائح أسبوعية للوالدين تساعدهم في تنمية هذه القيمة لدى أطفالهم إضافة لإتاحة مساحة للكتابة التأملية للوالدين لتطوير مهاراتهم التربوية في التعامل مع أطفالهم. ويشمل واجهة الإباء على الاتي:
-	إرسال المهام الى البناء وتحديد المدة والوقت والتاريخ لكل مهمه ولمن توكل من الأبناء
-	متابعة أداء البناء في انجاز المهام الموكلة لهم وارسال رسائل تشجيعية لهم.
-	تحديد المكافئات والجوائز لكل مهمة وشروط استحقاقها.
-	استقبال الاشعارات الخاصة بإنجاز الأطفال لمهامهم والرسائل المرسلة من قبلهم
-	صفحة توعوية للإباء تقم نصائح في التربية وطرق التعامل مع الأبناء
-	مساحة لتدوين الملاحظات اليومية والتأملات مع إمكانية إضافة صور
-	إضافة او حذف او تعديل المستخدمين داخل الأسرة
مميزات واجهة الأبناء: يشمل التطبيق أنشطة تنمي الذكاء العاطفي لدى الأطفال، كما يشجعهم على تقديم مبادرات لطيفة للوالدين والتعرف على تفضيلاتهم. يشجع التطبيق الأطفال على تحمل المسؤولية والمساعدة في بعض المهام المنزلية من خلال جدول المهام الذي يتم تنظيمه من قبل الوالدين. وتشمل واجهة الأبناء على التي:
-	استقبال المهام من الإباء ومعرفة التفاصيل وانهائها وارسال الى الوالدين
-	العاب ونشاطات ومنها:
o	لعبة تدوير عجلة الحظ ليتم اختيار بطاقة عشوائية فيها نشاط للطفل وبعد الانتهاء يسمح للطفل مشاركة النشاط مع الوالدين.
o	لعبة التلوين ويتم ظهور شخصيات مثل (اب، ام ، جد، جدة ) ليتم تلوينهم من قبل الطفل ثم يختار تفضيلاتهم وتلوينها أيضا ومن ثم مشاركة النتيجة مع الوالدين.
o	لعبة اكتشاف المشاعر وفيها عدد من المشاهد التخيلية للوالدين تظهر على ملامحهم مشاعر معينه حسب الموقف والمطلوب من الطفل ان يخمن بماذا يشعروا وما هو السبب
-	المكافئات وفيها تظهر جميع المكافئات المحددة من قبل والوالدين ليختار الطفل فيما بينها حسب استحقاقه.
-	الرسائل للوالدين اما ملصقات وصور او رسائل صوتية.

                        """,
                        style: TextStyle(
                            fontFamily: fontHiding2,
                            color: Colors.grey[800],
                            fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        child: Text(
                          'زيارة موقع الابن الرضي ',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () => launch('https://www.sononkau.xyz/'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
