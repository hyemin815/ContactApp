
import UIKit
import SnapKit

// UITableView는 자체적으로 데이터를 모르기 때문에 어디서 몇개의 셀을 가져와야하는지, 어떤 내용을 보여줘야하는지를 외부에 위임해야함. 그래서 UITableViewDataSource를 채택해서 필수 정보(tableView(_:numberOfRowsInSection:), tableView(_:cellForRowAt:))를 제공해줘야 함.
class ContactViewController: UIViewController, UITableViewDataSource {
    
    private let contactTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 80
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigation bar의 타이틀
        self.title = "친구 목록"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        // 오른쪽 상단 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(buttonTapped))
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(contactTableView)
        
        // 테이블 뷰에 데이터를 공급할 주체가 self(ContactViewController)라고 설정
        contactTableView.dataSource = self
        // 셀을 재사용하기 위해 미리 등록함. ContactTableViewCell 클래스의 타입 자체를 넘기기 위해 self 사용
        contactTableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactCell")
        // 구분선 여백 조정
        contactTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        contactTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    private var contacts: [Contact] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contacts = UserDefaults.standard.savedContacts
        contactTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }

        let contact = contacts[indexPath.row]
        let image = contact.imageData.flatMap { UIImage(data: $0) }
        cell.setContactInfo(name: contact.name, phoneNumber: contact.phoneNumber, image: image)
        return cell
    }
    

    
    @objc
    private func buttonTapped() {
        self.navigationController?.pushViewController(AddContactViewController(), animated: true)
    }
    
}


class ContactTableViewCell: UITableViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    // 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [
            profileImageView,
            nameLabel,
            phoneNumberLabel
        ].forEach { contentView.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.leading.equalToSuperview().offset(40)
            $0.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.trailing.equalToSuperview().offset(-40)
        }
    }
    
    // 서버에서 이미지를 못 받을 경우 앱 크러시가 날 수 있기 때문에 옵셔널 타입으로 작성
    func setContactInfo(name: String, phoneNumber: String, image: UIImage?) {
        nameLabel.text = name
        phoneNumberLabel.text = phoneNumber
        profileImageView.image = image
    }
}
