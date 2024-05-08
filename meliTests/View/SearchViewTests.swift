//
//  SearchViewTests.swift
//  meliTests
//
//  Created by jonnattan Choque on 7/05/24.
//

import XCTest
@testable import meli

final class SearchViewTests: XCTestCase {

    var viewController: SearchViewController!
    var mockPresenter: MockLoginPresenter!
    
    /**
        Configura el entorno necesario antes de cada prueba.

        - Prepara instancia simulada para el presenter
        - Configura la vista con la instancia simulada correspondiente
        - Se fuerza la carga de la vista para activar el ciclo de vida de la vista y configurar las interacciones..
    */
    override func setUp() {
        super.setUp()
        mockPresenter = MockLoginPresenter()
        
        viewController = SearchViewController()
        viewController.presenter = mockPresenter
        
        _ = viewController.view
    }
    
    /**
        Realiza la limpieza después de cada prueba.

        - Libera las instancias simuladas de la vista y el presentador.
    */
    override func tearDown() {
        viewController = nil
        mockPresenter = nil
        super.tearDown()
    }
    
    /**
        Verifica si el método `testResultSuccess` de la vista.

        - Given: Se crea una instancia de UINavigationController con la vista de búsqueda como raíz.
        - When: Se llama al método resultSuccess() de la vista.
        - Then:
            - Se verifica que el campo de texto de búsqueda se haya vaciado correctamente
            - Se verifica que el texto seleccionado se haya vaciado correctamente.
            - Se verifica que se haya llamado al método showNext del presentador simulado.
    */
    func testResultSuccess() {
        // Given
        _ = UINavigationController(rootViewController: viewController)
        
        // When
        viewController.resultSuccess()
        
        // Then
        XCTAssertEqual(viewController.searchTextField.text, "")
        XCTAssertEqual(viewController.textSelected, "")
        XCTAssertTrue(mockPresenter.didCallShowNext)
    }
    
    /**
        Verifica si método buttonPressed() de la vista cuando se presiona un botón.

        - Given: Se establece un texto seleccionado en la vista.
        - When: Se simula el evento de presionar un botón en la vista.
        - Then: Se verifica que se haya llamado al método de búsqueda del presentador simulado.
    */
    func testButtonPressed() {
        // Given
        viewController.textSelected = "Test"
        
        // When
        viewController.buttonPressed(UIButton())
        
        // Then
        XCTAssertTrue(mockPresenter.didCallSearch)
    }

    /// Prueba el método buttonPressed() de la vista cuando no hay ningún texto seleccionado.
    
    /**
        Verifica si  el método buttonPressed() de la vista cuando no hay ningún texto seleccionado.

        - Given: Se establece que no hay ningún texto seleccionado en la vista.
        - When: Se simula el evento de presionar un botón en la vista.
        - Then: Se verifica que no se haya llamado al método de búsqueda del presentador simulado.
    */
    func testButtonPressedFailed() {
        // Given
        viewController.textSelected = ""
        
        // When
        viewController.buttonPressed(UIButton())
        
        // Then
        XCTAssertFalse(mockPresenter.didCallSearch)
    }

}

/// Clase de mock para el presentador del módulo de búsqueda. Implementa el protocolo  `SearchPresenterProtocol`..
class MockLoginPresenter: SearchPresenterProtocol {
    /// Referencia simulada a la vista del módulo de búsqueda.
    var view: (any SearchViewProtocol)?
    
    /// Referencia simulada al interactor del módulo de búsqueda.
    var interactor: (any SearchInteractorProtocol)?
    
    /// Referencia simulada al enrutador del módulo de búsqueda.
    var router: (any SearchRouterProtocol)?
    
    /// Indicador booleano que registra si se llamó al método de búsqueda.
    var didCallSearch = false
    
    /// Indicador booleano que registra si se llamó al método para mostrar la siguiente vista.
    var didCallShowNext = false
    
    /**
        Método simulado para realizar una búsqueda.
     
        - Parameter text: El texto de búsqueda.
    */
    func search(text: String) {
        didCallSearch = true
    }
    
    /**
        Método simulado para mostrar la siguiente vista.
     
        - Parameter navigationController: El controlador de navegación.
    */
    func showNextView(navigationController: UINavigationController) {
        didCallShowNext = true
    }
}
