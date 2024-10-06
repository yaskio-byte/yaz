<!DOCTYPE html>
<html lang="ar">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>فضاء اللغات - تسجيل الدخول والدروس</title>
    <h2>فضاء اللغات</h2>


    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>

        body {
            font-family: 'Arial', sans-serif;
            direction: rtl;
            text-align: right;
            background: linear-gradient(to right, #74ebd5, #9face6);
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            background-color: white;
            margin-top: 100px;
            position: relative;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
        }
        .login-btn, .language-button {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.3s ease;
            font-size: 16px;
        }
        .login-btn:hover, .language-button:hover {
            background-color: #0056b3;
            transform: translateY(-2px);
        }
        .error-message {
            color: red;
            font-size: 14px;
            margin-top: 10px;
        }
        .hidden {
            display: none;
        }
        .language-button {
            background-color: #28a745;
        }
        .language-button:hover {
            background-color: #218838;
        }
        #lessonContainer p {
            background-color: #f0f0f0;
            padding: 10px;
            border-radius: 5px;
            margin-top: 5px;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
        }
        .modal-content {
            background-color: white;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 400px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.3);
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close:hover, .close:focus {
            color: #000;
        }
        input[type="email"], input[type="text"], input[type="password"] {
            width: calc(100% - 20px);
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            transition: border-color 0.3s ease;
        }
        input[type="email"]:focus, input[type="text"]:focus, input[type="password"]:focus {
            border-color: #007bff;
            outline: none;
        }
        @media (max-width: 600px) {
            .container {
                padding: 15px;
            }
            .login-btn, .language-button {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h2>فضاء اللغات</h2>
    
    <!-- زر تسجيل الدخول -->
    <button class="login-btn" id="loginBtn"><i class="fas fa-sign-in-alt"></i> تسجيل الدخول</button>
    <button class="login-btn" id="registerBtn"><i class="fas fa-user-plus"></i> تسجيل حساب جديد</button>

    <!-- قسم الدروس (مخفي افتراضيًا) -->
    <div id="lessonsSection" class="hidden">
        <h3>اختر لغة لعرض الدروس:</h3>
        <button class="language-button" onclick="showLessons('العربية')">العربية</button>
        <button class="language-button" onclick="showLessons('الإنجليزية')">الإنجليزية</button>
        <button class="language-button" onclick="showLessons('الفرنسية')">الفرنسية</button>
        <button class="language-button" onclick="showLessons('الإسبانية')">الإسبانية</button>
        <button class="language-button" onclick="showLessons('الألمانية')">الألمانية</button>
        <button class="language-button" onclick="showLessons('الإيطالية')">الإيطالية</button>
        
        <!-- قسم عرض الدروس -->
        <div id="lessonContainer"></div>
        <button class="login-btn" id="saveProgressBtn">حفظ التقدم</button>
    </div>

    <!-- زر تغيير كلمة المرور -->
    <button class="login-btn" id="changePasswordBtn" style="display: none;">تغيير كلمة المرور</button>
</div>

<!-- الـ Modal لتسجيل الدخول -->
<div id="loginModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h3><i class="fas fa-user-lock"></i> تسجيل الدخول</h3>
        <input type="email" id="email" placeholder="البريد الإلكتروني" required />
        <input type="text" id="phone" placeholder="رقم الهاتف المحمول" required />
        <button class="login-btn" onclick="login()">دخول</button>
        <p id="loginMessage" class="error-message"></p>
    </div>
</div>

<!-- الـ Modal لتسجيل الحساب الجديد -->
<div id="registerModal" class="modal">
    <div class="modal-content">
        <span class="close" id="closeRegisterModal">&times;</span>
        <h3><i class="fas fa-user-plus"></i> تسجيل حساب جديد</h3>
        <input type="text" id="newUsername" placeholder="اسم المستخدم" required />
        <input type="email" id="newEmail" placeholder="البريد الإلكتروني" required />
        <input type="password" id="newPassword" placeholder="كلمة المرور" required />
        <button class="login-btn" onclick="register()">تسجيل</button>
        <p id="registerMessage" class="error-message"></p>
    </div>
</div>

<!-- الـ Modal لتغيير كلمة المرور -->
<div id="changePasswordModal" class="modal">
    <div class="modal-content">
        <span class="close" id="closeChangePasswordModal">&times;</span>
        <h3><i class="fas fa-key"></i> تغيير كلمة المرور</h3>
        <input type="password" id="oldPassword" placeholder="كلمة المرور القديمة" required />
        <input type="password" id="newPasswordChange" placeholder="كلمة المرور الجديدة" required />
        <button class="login-btn" onclick="changePassword()">تغيير كلمة المرور</button>
        <p id="changePasswordMessage" class="error-message"></p>
    </div>
</div>

<script>
// قائمة اللغات المتاحة والدروس الخاصة بها
const lessons = {
    'العربية': [
        'السلام - التحية (مثل: السلام عليكم)',
        'مرحبا - أهلاً وسهلاً',
        'نعم - للإيجاب',
        'لا - للنفي',
        'من فضلك - لتطلب شيئًا بأدب',
        'شكرًا - للتعبير عن الامتنان',
        'كيف حالك؟ - للسؤال عن الحالة',
        'أنا بخير - للإجابة',
        'ما اسمك؟ - للسؤال عن الاسم',
        'أين تسكن؟ - للسؤال عن المكان',
        'عذرًا - للاعتذار',
        'إلى اللقاء - لقول وداعًا',
        'ما هذا؟ - للسؤال عن الشيء',
        'أحبك - للتعبير عن المشاعر',
        'هل يمكنك مساعدتي؟ - لطلب المساعدة',
        'أحتاج إلى - للتعبير عن الاحتياجات',
        'الأعداد: 0, 1, 2, ...'
    ],
    'الإنجليزية': [
        'Hello - التحية',
        'Yes - نعم',
        'No - لا',
        'Please - من فضلك',
        'Thank you - شكرًا',
        'How are you? - كيف حالك؟',
        'I am fine - أنا بخير',
        'What is your name? - ما اسمك؟',
        'Where do you live? - أين تسكن؟',
        'Sorry - عذرًا',
        'Goodbye - إلى اللقاء',
        'What is this? - ما هذا؟',
        'I love you - أحبك',
        'Can you help me? - هل يمكنك مساعدتي؟',
        'I need - أحتاج إلى',
        'Numbers: 0, 1, 2, ...'
    ],
    'الفرنسية': [
        'Bonjour - التحية',
        'Oui - نعم',
        'Non - لا',
        'S\'il vous plaît - من فضلك',
        'Merci - شكرًا',
        'Comment ça va? - كيف حالك؟',
        'Je vais bien - أنا بخير',
        'Comment vous appelez-vous? - ما اسمك؟',
        'Où habitez-vous? - أين تسكن؟',
        'Désolé - عذرًا',
        'Au revoir - إلى اللقاء',
        'Qu\'est-ce que c\'est? - ما هذا؟',
        'Je t\'aime - أحبك',
        'Pouvez-vous m\'aider? - هل يمكنك مساعدتي؟',
        'J\'ai besoin de - أحتاج إلى',
        'Nombres: 0, 1, 2, ...'
    ],
    'الإسبانية': [
        'Hola - التحية',
        'Sí - نعم',
        'No - لا',
        'Por favor - من فضلك',
        'Gracias - شكرًا',
        '¿Cómo estás? - كيف حالك؟',
        'Estoy bien - أنا بخير',
        '¿Cuál es tu nombre? - ما اسمك؟',
        '¿Dónde vives? - أين تسكن؟',
        'Lo siento - عذرًا',
        'Adiós - إلى اللقاء',
        '¿Qué es esto? - ما هذا؟',
        'Te quiero - أحبك',
        '¿Puedes ayudarme? - هل يمكنك مساعدتي؟',
        'Necesito - أحتاج إلى',
        'Números: 0, 1, 2, ...'
    ],
    'الألمانية': [
        'Hallo - التحية',
        'Ja - نعم',
        'Nein - لا',
        'Bitte - من فضلك',
        'Danke - شكرًا',
        'Wie geht\'s? - كيف حالك؟',
        'Mir geht\'s gut - أنا بخير',
        'Wie heißen Sie? - ما اسمك؟',
        'Wo wohnen Sie? - أين تسكن؟',
        'Entschuldigung - عذرًا',
        'Auf Wiedersehen - إلى اللقاء',
        'Was ist das? - ما هذا؟',
        'Ich liebe dich - أحبك',
        'Können Sie mir helfen? - هل يمكنك مساعدتي؟',
        'Ich brauche - أحتاج إلى',
        'Zahlen: 0, 1, 2, ...'
    ],
    'الإيطالية': [
        'Ciao - التحية',
        'Sì - نعم',
        'No - لا',
        'Per favore - من فضلك',
        'Grazie - شكرًا',
        'Come stai? - كيف حالك؟',
        'Sto bene - أنا بخير',
        'Qual è il tuo nome? - ما اسمك؟',
        'Dove vivi? - أين تسكن؟',
        'Mi dispiace - عذرًا',
        'Arrivederci - إلى اللقاء',
        'Che cos\'è questo? - ما هذا؟',
        'Ti amo - أحبك',
        'Puoi aiutarmi? - هل يمكنك مساعدتي؟',
        'Ho bisogno di - أحتاج إلى',
        'Numeri: 0, 1, 2, ...'
    ]
};

let userLessonsProgress = {};

function showLessons(language) {
    const lessonContainer = document.getElementById('lessonContainer');
    lessonContainer.innerHTML = `<h4>دروس ${language}</h4>`;
    lessons[language].forEach((lesson, index) => {
        lessonContainer.innerHTML += `<p>${index + 1}. ${lesson}</p>`;
    });
    userLessonsProgress[language] = userLessonsProgress[language] || [];
    document.getElementById('lessonsSection').classList.remove('hidden');
}

document.getElementById('loginBtn').onclick = function() {
    document.getElementById('loginModal').style.display = "block";
};

document.getElementById('registerBtn').onclick = function() {
    document.getElementById('registerModal').style.display = "block";
};

document.getElementById('changePasswordBtn').onclick = function() {
    document.getElementById('changePasswordModal').style.display = "block";
};

// Close modals
document.querySelectorAll('.close').forEach(element => {
    element.onclick = function() {
        this.closest('.modal').style.display = "none";
    };
});

// تسجيل الدخول
function login() {
    const email = document.getElementById('email').value;
    const phone = document.getElementById('phone').value;

    if (email === "" || phone === "") {
        document.getElementById('loginMessage').innerText = "يرجى ملء جميع الحقول.";
    } else {
        document.getElementById('loginMessage').innerText = "";
        document.getElementById('loginModal').style.display = "none";
        document.getElementById('lessonsSection').classList.remove('hidden');
        document.getElementById('changePasswordBtn').style.display = "inline";
    }
}

// تسجيل الحساب الجديد
function register() {
    const newUsername = document.getElementById('newUsername').value;
    const newEmail = document.getElementById('newEmail').value;
    const newPassword = document.getElementById('newPassword').value;

    if (newUsername === "" || newEmail === "" || newPassword === "") {
        document.getElementById('registerMessage').innerText = "يرجى ملء جميع الحقول.";
    } else {
        document.getElementById('registerMessage').innerText = "تم تسجيل الحساب بنجاح!";
        document.getElementById('registerModal').style.display = "none";
    }
}

// تغيير كلمة المرور
function changePassword() {
    const oldPassword = document.getElementById('oldPassword').value;
    const newPassword = document.getElementById('newPasswordChange').value;

    if (oldPassword === "" || newPassword === "") {
        document.getElementById('changePasswordMessage').innerText = "يرجى ملء جميع الحقول.";
    } else {
        document.getElementById('changePasswordMessage').innerText = "تم تغيير كلمة المرور بنجاح!";
        document.getElementById('changePasswordModal').style.display = "none";
    }
}

// حفظ التقدم
document.getElementById('saveProgressBtn').onclick = function() {
    alert("تم حفظ تقدمك بنجاح!");
};

</script>
</body>
</html>
