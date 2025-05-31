//
//  PrivacyPolicyViewController.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Aydınlatma Metni"
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        private let textView: UITextView = {
            let tv = UITextView()
            tv.isEditable = false
            tv.isScrollEnabled = true
            tv.font = UIFont.systemFont(ofSize: 16)
            tv.textColor = .black
            tv.translatesAutoresizingMaskIntoConstraints = false
            return tv
        }()

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            setupLayout()
            textView.text = kvkkText
        }

        private func setupLayout() {
            view.addSubview(titleLabel)
            view.addSubview(textView)

            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

                textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
                textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            ])
        }

        private let kvkkText = """
    1. Veri Sorumlusu ve Amaç
    Bu aydınlatma metni, Cetpe Bilet tarafından 6698 sayılı Kişisel Verilerin Korunması Kanunu ("KVKK") uyarınca hazırlanmıştır. Şirketimiz, kişisel verilerinizi hukuka uygun bir şekilde işlemek ve gizliliğinizi korumak amacıyla gerekli önlemleri almaktadır.

    2. İşlenen Kişisel Veriler
    Tarafımızca aşağıdaki kişisel verileriniz işlenmektedir:
    Ad, soyad, e-posta adresi, telefon numarası
    Kullanıcı davranışı ve işlem geçmişi
    İlgili ürün ve hizmetlerle bağlantılı diğer bilgiler

    3. Kişisel Verilerin İşlenme Amaçları
    Kişisel verileriniz şu amaçlarla işlenmektedir:
    - Talep ve şikâyetlerinizi karşılamak
    - Hizmet sunmak ve ürün geliştirmek
    - Kanuni yükümlülüklerimizi yerine getirmek
    - Size özel kampanya ve bilgilendirmeler yapmak

    4. Kişisel Verilerin Aktarılması
    Kişisel verileriniz yalnızca:
    - Hukuken yetkili kamu kurumlarıyla
    - İş ortaklarımız ve hizmet aldığımız tedarikçilerle paylaşılabilir.

    5. Toplama Yöntemi ve Hukuki Sebebi
    Kişisel verileriniz; web sitesi, mobil uygulamalar, çağrı merkezi ve diğer iletişim kanallarıyla, KVKK’nın 5. ve 6. maddelerine uygun olarak işlenmektedir.

    6. Haklarınız
    KVKK kapsamında aşağıdaki haklara sahipsiniz:
    - Kişisel verilerinizin işlenip işlenmediğini öğrenme
    - Eksik veya yanlış işlenmiş verilerin düzeltilmesini isteme
    - Verilerinizin silinmesini veya yok edilmesini talep etme
    - İşlemenin kanuna aykırı olması hâlinde zararların giderilmesini talep etme

    7. İletişim
    Kişisel verilerinizle ilgili sorularınız ve talepleriniz için bize ceptebilet@gmail.com üzerinden ulaşabilirsiniz.

    Cepte Bilet
    """

}
