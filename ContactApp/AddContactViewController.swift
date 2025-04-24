

import UIKit
import SnapKit


class AddContactViewController: UIViewController {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let setRandomImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "연락처 추가"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(saveContact))
        configureUI()
        setRandomImageButton.addTarget(self, action: #selector(loadRandomPokemonImage), for: .touchUpInside)
        
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [
            profileImageView,
            setRandomImageButton,
            nameTextField,
            phoneNumberTextField
        ].forEach { view.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(120)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        setRandomImageButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(setRandomImageButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(30)
        }
        
        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(30)
        }
        
    }
    
    @objc private func loadRandomPokemonImage() {
        let id = Int.random(in: 1...1000)
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let sprite = (json["sprites"] as? [String: Any])?["front_default"] as? String,
                  let imageUrl = URL(string: sprite) else {
                DispatchQueue.main.async { self?.profileImageView.image = nil }
                return
            }

            URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                let image = data.flatMap { UIImage(data: $0) }
                DispatchQueue.main.async { self?.profileImageView.image = image }
            }.resume()
        }.resume()
    }
    
    @objc private func saveContact() {
        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneNumberTextField.text, !phone.isEmpty else {
            return
        }

        let imageData = profileImageView.image?.pngData()
        let newContact = Contact(name: name, phoneNumber: phone, imageData: imageData)

        var current = UserDefaults.standard.savedContacts
        current.append(newContact)
        UserDefaults.standard.savedContacts = current

        navigationController?.popViewController(animated: true)
    }
}
