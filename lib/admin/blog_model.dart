import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kau_app/utils/app_theme.dart';

class BlogModel extends StatefulWidget {
  @override
  _BlogModelState createState() => _BlogModelState();
}

class _BlogModelState extends State<BlogModel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: myBackground,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              Navigator.pop(context, () {
                setState(() {});
              });
            },
          ),
          iconTheme: IconThemeData(
            color: myBink, //change your color here
          ),
          title: Text(
            "الكتابة التأملية",
            style: TextStyle(
              fontFamily: fontHiding1,
              fontSize: 25,
              color: myBink,
            ),
          ),
          backgroundColor: myBackground,
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Html(
              style: {
                "body": Style(
                  fontFamily: fontHiding2,
                ),
              },
              //        defaultTextStyle: TextStyle(fontFamily: fontHiding2),
              data: """
               <html>

<head>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<meta name=Generator content="Microsoft Word 15 (filtered)">


</head>

<body lang=EN-US style='word-wrap:break-word'>

<div class=WordSection1>

<p class=MsoTitle align=center dir=RTL style='text-align:center;direction:rtl;
unicode-bidi:embed'><span lang=AR-SA style='font-family:Tajawal'>التفكير
التأملي والمذكرات التأملية</span></p>

<p class=MsoNormal dir=RTL style='text-align:justify;direction:rtl;unicode-bidi:
embed'><b><span dir=LTR style='font-family:Tajawal'>&nbsp;</span></b></p>

<p class=MsoNormal dir=RTL style='text-align:justify;direction:rtl;unicode-bidi:
embed'><b><span lang=AR-SA style='font-family:Tajawal'>ما هو التفكير التأملي وكيف
يفيدنا كوالدين؟</span></b><span dir=LTR></span><span lang=AR-SA dir=LTR
style='font-family:Tajawal'><span dir=LTR></span> </span><span lang=AR-SA
style='font-family:Tajawal'>التفكير التأملي هو عملية ذهنية نشطة واعية حول
اعتقادات وخبرات الفرد بحيث يتمكن من خلالها الوصول إلى النتائج والحلول لمشكلات
تعترضه</span><span dir=LTR></span><span dir=LTR style='font-family:Tajawal'><span
dir=LTR></span>.</span><span dir=RTL></span><span style='font-family:Tajawal'><span
dir=RTL></span> <span lang=AR-SA>التفكير التأملي يعني الإدراك بأن السلوكيات
الظاهرة لها ارتباط بما يدور داخل عقل الشخص من عواطف أو معتقدات أو أهداف وأفكار،
فما يصدر عن طفلك من سلوك مرتبط بشيء ما داخل ذهنه الصغير، وكذلك بالنسبة للوالدين
فما تصدرانه من سلوكيات مرتبط بما يدور داخل أذهانكم في تلك اللحظة</span></span><span
dir=LTR></span><span dir=LTR style='font-family:Tajawal'><span dir=LTR></span>.</span><span
dir=RTL></span><span style='font-family:Tajawal'><span dir=RTL></span> <span
lang=AR-SA>يساعدنا التفكير التأملي في تقوية علاقتنا مع اطفالنا، فهذا النوع من
التفكير يشجع الوالدين على التأمل في سلوكياتهم وسلوكيات أطفالهم ويدفعهم لرؤية
الأحداث من منظورهم الخاص وكذلك من منظور أطفالهم</span></span><span dir=LTR></span><span
dir=LTR style='font-family:Tajawal'><span dir=LTR></span>.</span></p>

<h1 dir=RTL style='text-align:right;direction:rtl;unicode-bidi:embed'><span
lang=AR-SA style='font-family:Tajawal'>مثال على ذلك</span></h1>

<h2 dir=RTL style='text-align:right;direction:rtl;unicode-bidi:embed'><span
lang=AR-SA style='font-family:Tajawal'>الموقف الاول (الأم لا تمارس التفكير
التأملي)</span><span dir=LTR></span><span dir=LTR style='font-family:Tajawal'><span
dir=LTR></span>:</span></h2>

<p class=MsoNormal dir=RTL style='text-align:justify;direction:rtl;unicode-bidi:
embed'><span lang=AR-SA style='font-family:Tajawal'>إذا كان هناك شخصان يظهران
ردة فعلهما دون أن يفكر كلا منهما بالآخر فإنهما سيتعارضان بكل بساطة فعلى سبيل المثال،
الطفلة ترفض تنظيف أسنانها بالفرشاة قبل وقت النوم ، كان لدى الأم يوم طويل في
العمل وهي تشعر بالتعب الآن ، فتصرخ على طفلتها ( لقد تعبت من عدم سماعك لكلامي ،
لن أقرأ لك قصة قبل النوم اليوم) ، تستمر الطفلة في البكاء والأم في الصراخ دون
نتيجة</span><span dir=LTR></span><span dir=LTR style='font-family:Tajawal'><span
dir=LTR></span>.</span></p>

<h2 dir=RTL style='text-align:right;direction:rtl;unicode-bidi:embed'><span
lang=AR-SA style='font-family:Tajawal'>الموقف الثاني</span><span dir=LTR></span><span
lang=AR-SA dir=LTR style='font-family:Tajawal'><span dir=LTR></span> </span><span
dir=RTL></span><span lang=AR-SA style='font-family:Tajawal'><span dir=RTL></span>(الأم
تمارس التفكير التأملي)</span><span dir=LTR></span><span dir=LTR
style='font-family:Tajawal'><span dir=LTR></span>:</span></h2>

<p class=MsoNormal dir=RTL style='text-align:justify;direction:rtl;unicode-bidi:
embed'><span lang=AR-SA style='font-family:Tajawal'>الطفلة ترفض تنظيف أسنانها
بالفرشاة قبل وقت النوم، تشعر الأم بالغضب (لكن قبل أن تصدر الأم أي ردة فعل) فكرت
وأدركت أنها شعر بالتعب وسرعة الانفعال بعد يوم طويل في العمل، تدرك الأم أيضا أن
ابنتها ربما كانت مستاءة لأنها قاطعت وقت اللعب الخاص بهم للاستعداد للنوم.
تساعدها هذه الأفكار على الإبطاء في ردة فعلها ثم &quot;تحضن الأم طفلتها وتمسح
على رأسها وتقول لها أعلم أنه من الصعب التوقف عن اللعب، ما رأيك بعد أن تنظف أسنانك،
أن نقرأ قصة معا في غرفتك؟&quot; تهدأ الطفلة وتوافق على فكرة الام</span><span
dir=LTR></span><span dir=LTR style='font-family:Tajawal'><span dir=LTR></span>.</span></p>

<p class=MsoNormal dir=RTL style='text-align:right;direction:rtl;unicode-bidi:
embed'><span dir=LTR style='font-family:Tajawal'>&nbsp;</span></p>

<h1 dir=RTL style='text-align:right;direction:rtl;unicode-bidi:embed'><span
lang=AR-SA style='font-family:Tajawal'>كيف ستنعكس ممارسة الوالدين للتفكير
التأملي على أطفالهم؟</span></h1>

<p class=MsoNormal dir=RTL style='text-align:justify;direction:rtl;unicode-bidi:
embed'><span lang=AR-SA style='font-family:Tajawal'>أن تكون متأملاً في علاقة ما
يعني أن تكون مهت ًما وفضول ًيا بشأن المشاعر التي تدفع الوالدين أو الطفل للتصرف
بهذا الشكل فتسأل نفسك ما هي التجارب السابقة أو الحالية التي تؤثر على ما يفعله
أو يقوله كلأ منكما؟ إن التوقف مؤق ًتا وعدم إبداء ردة فعل سريعة وأخذ الوقت
الكافي للتفكير في دوافع السلوك يمنح كل شخص فرصة لفهم الآخر بشكل أفضل بدلاً من
مجرد الرد أو التصرف بشكل انفعالي</span><span dir=LTR></span><span dir=LTR
style='font-family:Tajawal'><span dir=LTR></span>.</span></p>

<p class=MsoNormal dir=RTL style='text-align:justify;direction:rtl;unicode-bidi:
embed'><span lang=AR-SA style='font-family:Tajawal'>ندما نحاول التواصل والتجاوب
مع أطفالنا فهم يشعرون بمحاولتنا ويعلمون بأننا معهم، في وسط أي صعوبة أو تجربة
يمرون بها. يحتاج الأطفال إلى الشعور بأن والديهم يفهمون مشاعرهم وسلوكياتهم - حتى
لو لم نتفق مع طريقة تصرفهم او مشاعرهم في تلك المواقف</span><span dir=LTR></span><span
dir=LTR style='font-family:Tajawal'><span dir=LTR></span>.</span></p>

<p class=MsoNormal dir=RTL style='text-align:justify;direction:rtl;unicode-bidi:
embed'><span lang=AR-SA style='font-family:Tajawal'>التفكير التأملي بلا شك يعني
أنه سيضمن لطفلك النمو السليم بعيداً عن التوتر والعصبية مما سينشئ علاقة قوية
بينك وبين طفلك، عندما شعر الأطفال بأن والديهم يتفهمون مشاعرهم فهذا سيساهم في
خلق علاقات أقوى بين الطفل ووالديه وكذلك بينه وبين إخوته وأصدقائه.  ما سيتعلم
طفلك منك القدرة على التفكير التأملي والتعامل مع التوتر وهذا سيساعده عندما يكبر
فيصبح راشداً مسؤولاً ومتفهماً</span><span dir=LTR></span><span dir=LTR
style='font-family:Tajawal'><span dir=LTR></span>.</span></p>

<p class=MsoNormal dir=RTL style='text-align:right;direction:rtl;unicode-bidi:
embed'><span dir=LTR style='font-family:Tajawal'>&nbsp;</span></p>

<h1 dir=RTL style='text-align:right;direction:rtl;unicode-bidi:embed'><span
lang=AR-SA style='font-family:Tajawal'>كيف أستخدم التفكير التأملي عند تعاملي مع
انفعالات أطفالي؟</span></h1>

<p class=MsoNormal dir=RTL style='text-align:right;direction:rtl;unicode-bidi:
embed'><span lang=AR-SA style='font-family:Tajawal'>اتبع الخطوات التالية</span><span
dir=LTR></span><span dir=LTR style='font-family:Tajawal'><span dir=LTR></span>:</span></p>

<p class=MsoListParagraphCxSpFirst dir=RTL style='margin-top:0in;margin-right:
.5in;margin-bottom:8.0pt;margin-left:0in;text-align:right;text-indent:-.25in;
direction:rtl;unicode-bidi:embed'><span style='font-family:Tajawal'>1.<span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
dir=RTL></span><span lang=AR-SA style='font-family:Tajawal'>توقف للحظة ولا تبدي
أي ردة فعل، خذ نفساً بطيئاً وعميقا</span><span dir=LTR></span><span dir=LTR
style='font-family:Tajawal'><span dir=LTR></span>.</span></p>

<p class=MsoListParagraphCxSpMiddle dir=RTL style='margin-top:0in;margin-right:
.5in;margin-bottom:8.0pt;margin-left:0in;text-align:right;text-indent:-.25in;
direction:rtl;unicode-bidi:embed'><span style='font-family:Tajawal'>2.<span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
dir=RTL></span><span lang=AR-SA style='font-family:Tajawal'>اجعل ذهنك حاضراً في
هذه اللحظة ولا تنشغل بأي شيء آخر</span><span dir=LTR></span><span dir=LTR
style='font-family:Tajawal'><span dir=LTR></span>.</span></p>

<p class=MsoListParagraphCxSpMiddle dir=RTL style='margin-top:0in;margin-right:
.5in;margin-bottom:8.0pt;margin-left:0in;text-align:right;text-indent:-.25in;
direction:rtl;unicode-bidi:embed'><span style='font-family:Tajawal'>3.<span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
dir=RTL></span><span lang=AR-SA style='font-family:Tajawal'>راقب سلوك طفلك
وسلوكك وقم بتصنيفه بالكلمات (بماذا يشعر طفلي الآن؟ ما</span><span dir=LTR></span><span
lang=AR-SA dir=LTR style='font-family:Tajawal'><span dir=LTR></span> </span><span
lang=AR-SA style='font-family:Tajawal'>الذي أشعر به الآن؟</span><span dir=LTR></span><span
dir=LTR style='font-family:Tajawal'><span dir=LTR></span> (</span></p>

<p class=MsoListParagraphCxSpMiddle dir=RTL style='margin-top:0in;margin-right:
.5in;margin-bottom:8.0pt;margin-left:0in;text-align:right;text-indent:-.25in;
direction:rtl;unicode-bidi:embed'><span style='font-family:Tajawal'>4.<span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
dir=RTL></span><span lang=AR-SA style='font-family:Tajawal'>فكر في سبب السلوك،
سلوك طفلك وسلوكك (بماذا أفكر انا في هذه اللحظة،</span><span dir=LTR></span><span
lang=AR-SA dir=LTR style='font-family:Tajawal'><span dir=LTR></span> </span><span
lang=AR-SA style='font-family:Tajawal'>بماذا يفكر طفلي؟ لماذا نتصرف بهذا الشكل؟</span><span
dir=LTR></span><span dir=LTR style='font-family:Tajawal'><span dir=LTR></span>
(</span></p>

<p class=MsoListParagraphCxSpLast dir=RTL style='margin-top:0in;margin-right:
.5in;margin-bottom:8.0pt;margin-left:0in;text-align:right;text-indent:-.25in;
direction:rtl;unicode-bidi:embed'><span style='font-family:Tajawal'>5.<span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
dir=RTL></span><span lang=AR-SA style='font-family:Tajawal'>بعد ان فهمت سبب
السلوك من الخطوات السابقة يمكنك الآن إبداء ردة فعل</span><span dir=LTR></span><span
lang=AR-SA dir=LTR style='font-family:Tajawal'><span dir=LTR></span> </span><span
lang=AR-SA style='font-family:Tajawal'>مناسبة للموقف (ما هو التصرف الأنسب في
هذا الموقف؟)</span></p>

<p class=MsoNormal dir=RTL style='text-align:right;direction:rtl;unicode-bidi:
embed'><span dir=LTR style='font-family:Tajawal'>&nbsp;</span></p>

<h1 dir=RTL style='text-align:right;direction:rtl;unicode-bidi:embed'><span
lang=AR-SA style='font-family:Tajawal'>خطوات كتابة المذكرات التأملية</span><span
dir=LTR></span><span dir=LTR style='font-family:Tajawal'><span dir=LTR></span>:</span></h1>

<p class=MsoNormal dir=RTL style='text-align:right;direction:rtl;unicode-bidi:
embed'><span lang=AR-SA style='font-family:Tajawal'>تساعدك كتابة المذكرات
التأملية للبدء في التفكير التأملي وتسهل عليك تطبيقه في حياتك اليومية خاصة في
المواقف التي تصادفك مع طفلك. خصص لنفسك وقتاً للكتابة واتبع الخطوات التالية
لتساعدك في كتابة تأملاتك</span><span dir=LTR></span><span dir=LTR
style='font-family:Tajawal'><span dir=LTR></span>:</span></p>

<p class=MsoListParagraphCxSpFirst dir=RTL style='margin-top:0in;margin-right:
.5in;margin-bottom:8.0pt;margin-left:0in;text-align:justify;text-indent:-.25in;
direction:rtl;unicode-bidi:embed'><span style='font-family:Tajawal'>1.<span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
dir=RTL></span><span lang=AR-SA style='font-family:Tajawal'>مرحلة الوصف، ابدأ
بكتابة وصف للموقف بالإجابة على هذه الأسئلة: ماذا حدث؟ متى حدث هذا الموقف، من
كان يتواجد في الموقف، ماهي ردود الأفعال في هذا الموقف؟ ماذا كانت النتيجة؟</span></p>

<p class=MsoListParagraphCxSpMiddle dir=RTL style='margin-top:0in;margin-right:
.5in;margin-bottom:8.0pt;margin-left:0in;text-align:justify;text-indent:-.25in;
direction:rtl;unicode-bidi:embed'><span style='font-family:Tajawal'>2.<span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
dir=RTL></span><span lang=AR-SA style='font-family:Tajawal'>مرحلة المشاعر، صف
مشاعرك في ذلك الموقف، فكر في أفكارك ومشاعرك في ذلك الوقت. في هذه المرحلة، حاول أن
تذكر وتستكشف الأشياء التي كانت تجري داخل رأسك، أي لماذا يبقى هذا الحدث في ذهنك؟
كيف شعرت في ذلك الوقت؟ لماذا حسست بهذا الشعور؟ ماهي الأسباب التي جعلتك تشعر
بهذا الشعور؟ ما هو شعور طفلك في هذا الموقف؟ ما هو شعورك بعد هذا الموقف؟</span></p>

<p class=MsoListParagraphCxSpMiddle dir=RTL style='margin-top:0in;margin-right:
.5in;margin-bottom:8.0pt;margin-left:0in;text-align:justify;text-indent:-.25in;
direction:rtl;unicode-bidi:embed'><span style='font-family:Tajawal'>3.<span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
dir=RTL></span><span lang=AR-SA style='font-family:Tajawal'>مرحلة التقييم، قيم
تجربتك في هذا الموقف كيف سارت الأمور؟ ماهي الأمور الإيجابية والسلبية في هذه
التجربة؟ هل كان التصرف الذي قمت به إيجابي أم سلبي؟ هل شعرت أن الموقف قد تم حله
بعد ذلك؟</span></p>

<p class=MsoListParagraphCxSpMiddle dir=RTL style='margin-top:0in;margin-right:
.5in;margin-bottom:8.0pt;margin-left:0in;text-align:justify;text-indent:-.25in;
direction:rtl;unicode-bidi:embed'><span style='font-family:Tajawal'>4.<span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
dir=RTL></span><span lang=AR-SA style='font-family:Tajawal'>مرحلة التحليل، في
هذه المرحلة ستتمكن من فهم الموقف الذي حدث بتحليلك لأسبابه كما يمكن فهمه بصورة
علمية من خلال الاستعانة بالنظريات التربوية أو آراء الخبراء التربويين أو الكتب التربوية،
حتى تصل للإجابة عن السبب في سير الأمور بهذا الشكل سواء للأفضل أو للأسوأ، هل
بإمكاني التصرف بطريقة مختلفة؟ هل هناك تصرف اتبعته ساهم في تحسين الموقف أو جعله أسوء؟</span></p>

<p class=MsoListParagraphCxSpMiddle dir=RTL style='margin-top:0in;margin-right:
.5in;margin-bottom:8.0pt;margin-left:0in;text-align:justify;text-indent:-.25in;
direction:rtl;unicode-bidi:embed'><span style='font-family:Tajawal'>5.<span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
dir=RTL></span><span lang=AR-SA style='font-family:Tajawal'>مرحلة الوصول
للقرار، وفيها تذكر ما الذي تعلمته بشكل عام أو ما تعلمته بصورة محددة، ما الذي
يمكنني فعله الآن بشكل أفضل؟ ما المهارات التي سأحتاجها للتعامل مع هذا بشكل أفضل؟</span></p>

<p class=MsoListParagraphCxSpLast dir=RTL style='margin-top:0in;margin-right:
.5in;margin-bottom:8.0pt;margin-left:0in;text-align:justify;text-indent:-.25in;
direction:rtl;unicode-bidi:embed'><span style='font-family:Tajawal'>6.<span
style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
dir=RTL></span><span lang=AR-SA style='font-family:Tajawal'>مرحلة وضع خطة العمل،
تلخص فيها أي شيء تحتاج إلى معرفته و تحسينه في المرة القادمة ، كيف و أين يمكنني
استخدام معرفتي وخبرتي الجديدة؟ كيف يمكنني تعديل أفعالي أو تحسين مهاراتي؟ إذا
حدث نفس الشيء مرة أخرى، فماذا أفعل بشكل مختلف؟</span></p>

<p class=MsoNormal dir=RTL style='text-align:right;direction:rtl;unicode-bidi:
embed'><span dir=LTR style='font-family:Tajawal'>&nbsp;</span></p>

<h1 dir=RTL style='text-align:right;direction:rtl;unicode-bidi:embed'><span
lang=AR-SA style='font-family:Tajawal'>نموذج لكتابة تأملية</span><span dir=LTR></span><span
dir=LTR style='font-family:Tajawal'><span dir=LTR></span>:</span></h1>

<p class=MsoNormal dir=RTL style='text-align:justify;direction:rtl;unicode-bidi:
embed'><span lang=AR-SA style='font-family:Tajawal'>كان لدي الكثير من العمل
اليوم اضافة الى الأعمال المنزلية التي خططت لإنهائها ، اضافة لزيارة أسرتي في
المساء ، استيقظت طفلتي مبكراً في هذا اليوم، في المساء ذهبنا لزيارة أسرتي كانت
طفلتي مزاجية على غير العادة بينما كنت أتصفح مع أخي بعض المواقع على الإنترنت
كانت طفلتي تركض وتقفز وعندما طلبت منها الهدوء جاءت وأغلقت شاشة الكمبيوتر
المحمول بقوة ، صرخت عليها مما دفعها للبكاء، كانت مشاعري مختلطة بين الحزن على
طفلتي لأني صرخت عليها والغضب من تصرفها والاستغراب من سلوكها المفاجئ على غير
العادة ، شعرت طفلتي بالحزن بالتأكيد وانخرطت في البكاء والذي رأيته من وجهة نظري
غير مبرر ، كانت ردة فعلي بلا شك خاطئة خاصة انني أحرجتها أمام أسرتي وهي طفلة
حساسة جداً، بعد أن هدأنا واحتضنت طفلتي تذكرت أنها لم تنام في فترة القيلولة
اليوم، لذلك هي تتصرف بهذا الشكل لأنها تشعر بالإرهاق وترغب في اللعب في نفس الوقت
، تذكرت شعوري عندما أتجاوز وقت نومي لإنجاز بعض المهام مزيج بين ألم الجسد وعدم
التركيز وسرعة الانفعال، ما زاد الموقف سو ًء هو ردة فعلي على تصرفها ، علمني هذا
الموقف ضرورة التركز على روتين نوم طفلتي ، وأحتاج أيضاً لتقسيم مهامي بشكل صحيح
حتى لا أنشغل عن طفلتي ويتكرر نفس  الموقف ، قد يكون من المناسب أن أكتب روتين
طفلتي وأضعه في مكان واضح في المنزل او أضبط التقويم الشخصي في الجوال لتحديد
روتينها اليومي، وفي حال تكرر نفس الموقف مرة أخرى سأتنفس بعمق ولن أبدى ردة فعل
سريعة سأتحدث مع طفلتي لأفهم سبب تصرفها وعندما تهدأ أوضح لها كيف تعبر عن مشاعرها
بشكل صحيح</span><span dir=LTR></span><span dir=LTR style='font-family:Tajawal'><span
dir=LTR></span>.</span></p>

</div>

</body>

</html>

                   """,
              // padding: EdgeInsets.all(8.0),

              onLinkTap: (url, _, __, ___) {
                print("Opening $url...");
              },
              // customRenders: (node, children) {
              //   if (node is dom.Element) {
              //     switch (node.localName) {
              //       case "custom_tag": // using this, you can handle custom tags in your HTML
              //         return Column(children: children);
              //     }
              //   }
              // },
              customRenders: {
                tagMatcher("custom_tag"):
                    CustomRender.widget(widget: (context, buildChildren) {
                  return Column(
                      children: [Text("tttttttttttest")] /*buildChildren*/);
                }),
              },
              tagsList: Html.tags..addAll(["custom_tag"]),
            ),
          ),
        ),
      ),
    );
  }
}
