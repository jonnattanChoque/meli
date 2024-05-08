//
//  ListPresenterTests.swift
//  meliTests
//
//  Created by jonnattan Choque on 6/05/24.
//

import XCTest
@testable import meli

final class ListPresenterTests: XCTestCase {
    var presenter: ListPresenter!
    var mockRouter: MockListRouter!
    
    /**
        Configura el entorno necesario antes de cada prueba.

        - Prepara instancias simuladas para el enrutador.
        - Configura el presentador con la instancia simulada correspondiente.
    */
    override func setUp() {
        super.setUp()
        
        mockRouter = MockListRouter()
        
        presenter = ListPresenter()
        presenter.router = mockRouter
    }

    /**
        Realiza la limpieza después de cada prueba.

        - Libera las instancias simuladas del enrutador y el presentador.
    */
    override func tearDown() {
        mockRouter = nil
        presenter = nil
        super.tearDown()
    }
    
    /**
        Prueba el método `showDetail` del presentador.

        Este método comprueba si el presentador puede mostrar los detalles de un artículo cuando se llama al método `showDetail`. Verifica si se llama al método `createPush` del enrutador para navegar a la pantalla de detalle.

        - Given: Se crea un controlador de navegación y se proporciona un identificador de artículo.
        - When: Se llama al método `showDetail` del presentador con el controlador de navegación y el identificador dados.
        - Then: Se verifica si se llamó al método `createPush` del enrutador para navegar a la pantalla de detalle.
    */
    func testShowDetail() {
        // Given
        let navigationController = UINavigationController()
        let id = "MLA1413551701"
        
        // When
        presenter.showDetail(navigationController: navigationController, id: id)
        
        // Then
        XCTAssertTrue(mockRouter.createPushCalled)
    }

}

/// Clase de mock para el enrutador de lista, implementando el protocolo `ListRouterProtocol`.
class MockListRouter: ListRouterProtocol {
    /// Indica si el método `createModule(result:)` fue llamado.
    var createModuleCalled = false
    
    /// Indica si el método `pushToDetailScreen(navigationController:id:)` fue llamado.
    var createPushCalled = false
    
    
    /**
        Método estático para crear un módulo de lista.
        - Parameter 
            - result: El modelo de resultados de búsqueda para crear el módulo de lista.
        - Returns: La instancia de `ListViewController` creada.
    */
    static func createModule(result: SearchModel) -> ListViewController {
        MockSearchRouter().createModuleCalled = true
        return ListViewController()
    }
    
    /**
        Método que simula la navegación a la pantalla de detalle.
        - Parameters:
            - navigationController: El controlador de navegación actual.
            - id: El identificador del elemento para mostrar el detalle.
    */
    func pushToDetailScreen(navigationController: UINavigationController, id: String) {
        createPushCalled = true
    }
}
