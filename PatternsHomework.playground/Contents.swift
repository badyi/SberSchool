import UIKit

//MARK: - Builder
final class TextFieldBuilder {
    public private(set) var placeholderText: String = ""
    public private(set) var placeholderTextColor: UIColor = .black
    public private(set) var delegate: UITextFieldDelegate? = nil
    public private(set) var translatesAutoresizingMaskIntoConstraints: Bool = true
    public private(set) var cornerRadius: CGFloat = 0
    public private(set) var backgroundColor: UIColor = .black
    public private(set) var maskedCorners: CACornerMask = []
    public private(set) var paddingViewFlag: Bool = false
    public private(set) var autocapitalizationType: UITextAutocapitalizationType = .sentences
    public private(set) var returnKeyType: UIReturnKeyType = .default
    public private(set) var autocorrectionType: UITextAutocorrectionType = .default
}

extension TextFieldBuilder {
    @discardableResult
    public func setPlaceholder(text: String) -> TextFieldBuilder {
        placeholderText = text
        return self
    }
    
    @discardableResult
    public func placeholderTextColor(_ color: UIColor) -> TextFieldBuilder {
        placeholderTextColor = color
        return self
    }
    
    @discardableResult
    public func delegate(_ delegate: UITextFieldDelegate) -> TextFieldBuilder {
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    public func translatesAutoresizingMaskIntoConstraints(_ flag: Bool) -> TextFieldBuilder {
        translatesAutoresizingMaskIntoConstraints = flag
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ radius: CGFloat) -> TextFieldBuilder {
        cornerRadius = radius
        return self
    }
    
    @discardableResult
    public func backgroundColor(_ color: UIColor) -> TextFieldBuilder {
        backgroundColor = color
        return self
    }
    
    @discardableResult
    public func maskedCorners(_ corners: CACornerMask) -> TextFieldBuilder {
        maskedCorners = corners
        return self
    }
    
    @discardableResult
    public func addPaddingView(_ flag: Bool) -> TextFieldBuilder {
        paddingViewFlag = true
        return self
    }
    
    @discardableResult
    public func autocapitalizationType(_ type: UITextAutocapitalizationType) -> TextFieldBuilder {
        autocapitalizationType = type
        return self
    }
    
    @discardableResult
    public func returnKeyType(_ type: UIReturnKeyType) -> TextFieldBuilder {
        returnKeyType = type
        return self
    }
    
    @discardableResult
    public func autocorrectionType(_ type: UITextAutocorrectionType) -> TextFieldBuilder {
        autocorrectionType = type
        return self
    }
    
    public func build() -> UITextField {
        let textField = UITextField()

        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: placeholderTextColor])
        textField.placeholder = placeholderText
        textField.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        textField.layer.cornerRadius = cornerRadius
        textField.backgroundColor = backgroundColor
        textField.layer.maskedCorners = maskedCorners
        
        if delegate != nil {
            textField.delegate = delegate
        }
        
        if paddingViewFlag {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }
        
        return textField
    }
}
enum AuthType {
    case google, facebook, phone
}

protocol LoginPresenterProtocol: AnyObject {
    var loginType: AuthType { get set }
    var credentials: [String: String] { get set }
}
protocol SignUpPresenterProtocol: AnyObject {
    var signUpType: AuthType { get set }
    var credentials: [String: String] { get set }
}

final class LoginPresenter: LoginPresenterProtocol {
    var loginType: AuthType
    var credentials: [String: String]
    
    init(with credentials: [String: String], _ type: AuthType) {
        self.credentials = credentials
        self.loginType = type
    }
}

final class SignUpPresenter: SignUpPresenterProtocol {
    var signUpType: AuthType
    var credentials: [String : String]
    
    init(with credentials: [String: String], _ type: AuthType) {
        self.credentials = credentials
        self.signUpType = type
    }
}

final class LoginViewController: UIViewController, UITextFieldDelegate {
    var presenter: LoginPresenterProtocol
    
    init(with presenter: LoginPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Builder usage
    lazy var emailField: UITextField = {
        return TextFieldBuilder()
            .autocorrectionType(.no)
            .autocapitalizationType(.none)
            .returnKeyType(.continue)
            .setPlaceholder(text: "Email")
            .placeholderTextColor(.gray)
            .delegate(self)
            .translatesAutoresizingMaskIntoConstraints(false)
            .cornerRadius(10)
            .backgroundColor(.cyan)
            .maskedCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner])
            .addPaddingView(true)
            .build()
    }()
}

final class SignUpViewController: UIViewController {
    var presenter: SignUpPresenterProtocol
    
    init(with presenter: SignUpPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Abstract Factory
protocol AuthViewControllerFactoryProtocol {
    func createLoginViewController() -> UIViewController
    func createSignUpViewController() -> UIViewController
}

final class GoogleAuthViewControllerFactory: AuthViewControllerFactoryProtocol {
    func createLoginViewController() -> UIViewController {
        return LoginViewController(with: LoginPresenter(with: ["SomeKey" : "12345"], .google))
    }
    
    func createSignUpViewController() -> UIViewController {
        return SignUpViewController(with: SignUpPresenter(with: ["SomeKey" :" 789243"], .google))
    }
}

final class FaceBookAuthViewControllerFactory: AuthViewControllerFactoryProtocol {
    func createLoginViewController() -> UIViewController {
        return LoginViewController(with: LoginPresenter(with: ["SomeKey" : "1453"], .facebook))
    }
    
    func createSignUpViewController() -> UIViewController {
        return SignUpViewController(with: SignUpPresenter(with: ["SomeKey" : "5489"], .facebook))
    }
}
