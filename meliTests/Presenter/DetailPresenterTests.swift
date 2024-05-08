//
//  DetailPresenterTests.swift
//  meliTests
//
//  Created by jonnattan Choque on 6/05/24.
//

import XCTest
@testable import meli

final class DetailPresenterTests: XCTestCase {

    var presenter: DetailPresenter!
    var mockView: MockDetailView!
    var mockRouter: MockDetailRouter!
    var mockInteractor: MockDetailInteractor!
    
    /**
        Configura el entorno necesario antes de cada prueba.

        - Prepara instancias simuladas para la vista, el interactor y el enrutador.
        - Configura el presentador con las instancias simuladas correspondientes.
    */
    override func setUp() {
        super.setUp()
        
        mockView = MockDetailView()
        mockInteractor = MockDetailInteractor()
        mockRouter = MockDetailRouter()
        
        presenter = DetailPresenter()
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
        presenter.view = mockView
    }

    /**
        Realiza la limpieza después de cada prueba.

        - Libera las instancias simuladas de la vista, el interactor, el enrutador y el presentador.
    */
    override func tearDown() {
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        presenter = nil
        
        super.tearDown()
    }

    /**
        Verifica si el método `viewDidLoad` del presentador realiza la solicitud de detalles al interactor.

        - Dado: Un identificador de detalle.
        - Cuando: Se llama al método `viewDidLoad` del presentador con el identificador dado.
        - Entonces: Se verifica que se haya llamado al método `responseDetail` del interactor.
    */
    func testViewDidLoad() {
        // Given
        let id = "MLA1413551701"
        
        // When
        presenter.viewDidLoad(id: id)
        
        // Then
        XCTAssertTrue(mockInteractor.responseDetailCalled)
    }

    /**
        Verifica si el método `back` del presentador realiza la navegación hacia atrás a través del router.

        - Given: Un controlador de navegación.
        - When: Se llama al método `back` del presentador con el controlador de navegación dado.
        - Then: Se verifica que se haya llamado al método `back` del router.
    */
    func testBack() {
        // Given
        let navigationController = UINavigationController()
        
        // When
        presenter.back(navigation: navigationController)
        
        // Then
        XCTAssertTrue(mockRouter.backCalled)
    }

    /**
        Verifica si el método `detailFetchedSuccess` del presentador maneja correctamente la respuesta exitosa del detalle y del vendedor.

        - Given: Un modelo de detalle y un modelo de vendedor.
        - When: Se llama al método `detailFetchedSuccess` del presentador con los modelos de detalle y vendedor dados.
        - Then: Se verifica que se haya llamado al método `resultSuccess` de la vista.
    */
    func testDetailFetchedSuccess() {
        // Given
        let response = self.getDetailModel()!
        let seller = self.getSellerModel()!
        
        // When
        presenter.detailFetchedSuccess(results: response, seller: seller)
        
        // Then
        XCTAssertTrue(mockView.resultSuccessCalled)
    }

    /**
        Verifica si el método `detailFetchFailed` del presentador maneja correctamente la falla en la obtención de detalles.

        - When: Se llama al método `detailFetchFailed` del presentador.
        - Then: Se verifica que se haya llamado al método `showErrorResults` de la vista.
    */
    func testDetailFetchFailed() {
        // When
        presenter.detailFetchFailed()
        
        // Then
        XCTAssertTrue(mockView.showErrorResultsCalled)
    }

    /**
        Verifica si el método `detailFetchEmpty` del presentador maneja correctamente la respuesta vacía al obtener detalles.

        - When: Se llama al método `detailFetchEmpty` del presentador.
        - Then: Se verifica que se haya llamado al método `showEmptyResults` de la vista.
    */
    func testDetailFetchEmpty() {
        // When
        presenter.detailFetchEmpty()
        
        // Then
        XCTAssertTrue(mockView.showEmptyResultsCalled)
    }

    /**
        Retorna un objeto `DetailModel` con datos de ejemplo.

        - Returns: Un objeto `DetailModel` con datos de ejemplo.
    */
    func getDetailModel() -> DetailModel? {
        let jsonString = """
            {
              "id": "MLA1413551701",
              "site_id": "MLA",
              "title": "Moto G6 32 Gb Índigo Oscuro 3 Gb Ram",
              "seller_id": 266122468,
              "price": 179600,
              "base_price": 179600,
              "original_price": null,
              "currency_id": "ARS",
              "initial_quantity": 7,
              "buying_mode": "buy_it_now",
              "condition": "new",
              "permalink": "https://articulo.mercadolibre.com.ar/MLA-1413551701-moto-g6-32-gb-indigo-oscuro-3-gb-ram-_JM",
              "pictures": [
                {
                    "id": "632562-MLA31003470563_062019",
                    "secure_url": "https://http2.mlstatic.com/D_632562-MLA31003470563_062019-O.jpg"
                }
              ],
              "accepts_mercadopago": true,
              "international_delivery_mode": "none",
              "seller_address": 
                {
                    "city": {
                      "id": "QVItQkJvdWxvZ25l",
                      "name": "Boulogne"
                    },
                    "state": {
                      "id": "AR-B",
                      "name": "Buenos Aires"
                    },
                    "country": {
                      "id": "AR",
                      "name": "Argentina"
                    },
                    "id": 279382025
                  },
              "attributes": [
                {
                  "id": "BATTERY_CAPACITY",
                  "name": "Capacidad de la batería",
                  "value_name": "3000 mAh"
                }
              ],
              "last_updated": "2024-05-03T14:38:03.000Z"
            }
            """
        
        // Crear un objeto DetailModel a partir del JSON
        let response = DetailModel(JSONString: jsonString)
        
        return response
    }
    
    /**
        Retorna un objeto `SellerModel` con datos de ejemplo.

        - Returns: Un objeto `SellerModel` con datos de ejemplo.
    */
    func getSellerModel() -> SellerModel? {
        let jsonString = """
            {
              "id": 266122468,
              "nickname": "OSCARCORTESCONDE",
              "country_id": "AR",
              "address": {
                "city": "Boulogne",
                "state": "AR-B"
              },
              "user_type": "normal",
              "site_id": "MLA",
              "permalink": "http://perfil.mercadolibre.com.ar/OSCARCORTESCONDE",
              "seller_reputation": {
                "level_id": "5_green",
                "power_seller_status": "silver",
                "transactions": {
                  "period": "historic",
                  "total": 157
                }
              }
            }
            """
        
        // Crear un objeto SellerModel a partir del JSON
        let response = SellerModel(JSONString: jsonString)
        
        return response
    }
}

/// Clase de mock para la vista de búsqueda, implementando el protocolo `DetailViewProtocol`.
class MockDetailView: DetailViewProtocol {
    /// Indica si el método `showEmptyResults()` fue llamado.
    var showEmptyResultsCalled = false
    
    /// Indica si el método `showErrorResults()` fue llamado.
    var showErrorResultsCalled = false
    
    /// Indica si el método `resultSuccess()` fue llamado.
    var resultSuccessCalled = false
    
    /**
        Muestra un mensaje de resultados vacíos.
        
        Este método se llama cuando no hay resultados que mostrar en la vista de detalle.
    */
    func showEmptyResults() {
        showEmptyResultsCalled = true
    }
    
    /**
        Muestra un mensaje de error.
        
        Este método se llama cuando ocurre un error al cargar los datos en la vista de detalle.
    */
    func showErrorResults() {
        showErrorResultsCalled = true
    }
    
    /**
        Realiza acciones después de que se obtienen los resultados exitosamente.
        
        Este método se llama cuando los resultados se cargan exitosamente en la vista de detalle.
    */
    func resultSuccess() {
        resultSuccessCalled = true
    }
}

/// Clase de mock para el enrutador de detalle, implementando el protocolo `DetailRouterProtocol`.
class MockDetailRouter: DetailRouterProtocol {
    /// Indica si el método `createModule(id:)` fue llamado.
    var createModuleCalled = false
    
    /// Indica si el método `backView(navigation:)` fue llamado.
    var backCalled = false
    
    /**
        Método estático para crear un módulo de búsqueda.
        - Parameter 
            - id: El identificador del detalle.
        - Returns: Una instancia de `DetailViewController`
    */
    static func createModule(id: String) -> DetailViewController {
        MockDetailRouter().createModuleCalled = true
        return DetailViewController()
    }
    
    /**
        Navega hacia atrás en la vista de detalle.
        - Parameter 
            - navigation: El controlador de navegación utilizado para la navegación.
    */
    func backView(navigation: UINavigationController) {
        backCalled = true
    }
}


/// Clase de mock para el interactor de detalle, implementando el protocolo `DetailInteractorProtocol`.
class MockDetailInteractor: DetailInteractorProtocol {
    /// El presentador asociado al interactor simulado.
    var presenter: (any DetailPresenterViewProtocol)?
    
    /// Indica si el método `detailInfo(id:)` fue llamado.
    var responseDetailCalled = false
    
    /**
        Recupera la información del detalle.
        
        - Parameter 
            - id: El identificador del detalle.
    */
    func detailInfo(id: String) {
        responseDetailCalled = true
    }
}
