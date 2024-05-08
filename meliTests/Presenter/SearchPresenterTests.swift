//
//  SearchPresenterTests.swift
//  meliTests
//
//  Created by jonnattan Choque on 2/05/24.
//

import XCTest
@testable import meli

final class SearchPresenterTests: XCTestCase {

    var presenter: SearchPresenter!
    var mockView: MockSearchView!
    var mockRouter: MockSearchRouter!
    var mockInteractor: MockSearchInteractor!
    
    /**
        Configura el entorno necesario antes de cada prueba.

        - Prepara instancias simuladas para la vista, el interactor y el enrutador.
        - Configura el presentador con las instancias simuladas correspondientes.
    */
    override func setUp() {
        super.setUp()
        
        mockView = MockSearchView()
        mockInteractor = MockSearchInteractor()
        mockRouter = MockSearchRouter()
        
        presenter = SearchPresenter()
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
        Verifica que al llamar al método `search` del presentador con un texto de búsqueda dado, se inicie correctamente la búsqueda a través del interactor.

        - Given: Se establece un texto de búsqueda específico.
        - When: Se llama al método `search` del presentador con el texto de búsqueda establecido.
        - Then: Se verifica que se haya llamado al método `searchInfo` del interactor, indicando que se ha iniciado una búsqueda.
    */
    func testSearch() {
        // Given
        let text = "iphone"
        
        // When
        presenter.search(text: text)
        
        // Then
        XCTAssertTrue(mockInteractor.responseSearchCalled)
    }

    /**
        Verifica que al llamar al método `showNextView` del presentador

        - Given: Se crea un controlador de navegación y un modelo de búsqueda.
        - When: Se llama al método `showNextView` del presentador con el controlador de navegación y el modelo de búsqueda.
        - Then: Se verifica que se haya llamado al método `createPush` del enrutador, indicando que se ha creado correctamente una nueva vista.
    */
    func testShowNextView() {
        // Given
        let navigationController = UINavigationController()
        let response = self.getSearchModel()
        
        // When
        presenter.response = response
        presenter.showNextView(navigationController: navigationController)
        
        // Then
        XCTAssertTrue(mockRouter.createPushCalled)
    }


    
    /**
        Verifica que al llamar al método `searchFetchedSuccess` del presentador

        - Given: Se obtiene un modelo de búsqueda válido.
        - When: Se llama al método `searchFetchedSuccess` del presentador con el modelo de búsqueda.
        - Then: Se verifica que se haya llamado al método `resultSuccess` de la vista, indicando que los resultados de la búsqueda se han recibido con éxito.
    */
    func testSearchFetchedSuccess() {
        // Given
        let response = self.getSearchModel()!
        
        // When
        presenter.searchFetchedSuccess(results: response)
        
        // Then
        XCTAssertTrue(mockView.resultSuccessCalled)
    }

    /**
        Verifica el método `searchFetchFailed()` del presentador cuando falla la búsqueda.

        - When:  Llamamos al método `searchFetchFailed()` del presentador para simular el fallo de la búsqueda.
        - Then: Se verifica si el método `showErrorResultsCalled` de la vista fue llamado, lo que indica que se mostró un mensaje de error al fallar la búsqueda.
    */
    func testSearchFetchFailed() {
        // When
        presenter.searchFetchFailed()
        
        // Then
        XCTAssertTrue(mockView.showErrorResultsCalled)
    }
    
    /**
        Verifica el método `searchFetchEmpty()`  del presentador cuando la búsqueda no devuelve resultados.

        - When: Llamamos al método `searchFetchEmpty()` del presentador para simular la situación en la que la búsqueda no devuelve resultados.
        - Then: Se verifica si el método `showEmptyResultsCalled` de la vista fue llamado, lo que indica que se mostró un mensaje de resultados vacíos.
    */
    func testSearchFetchEmpty() {
        // When
        // Ejecución:
        presenter.searchFetchEmpty()
        
        // Then
        XCTAssertTrue(mockView.showEmptyResultsCalled)
    }

    
    /**
        Retorna un objeto `SearchModel` con datos de ejemplo.

        - Returns: Un objeto `SearchModel` con datos de ejemplo.
    */
    func getSearchModel() -> SearchModel? {
        let jsonString = """
            {
              "site_id": "MLA",
              "country_default_time_zone": "GMT-03:00",
              "query": "Motorola G6",
              "paging": {
                "total": 74,
                "primary_results": 27,
                "offset": 0,
                "limit": 50
              },
              "results": [
                {
                  "id": "MLA1413551701",
                  "title": "Moto G6 32 Gb Índigo Oscuro 3 Gb Ram",
                  "condition": "new",
                  "thumbnail_id": "632562-MLA31003470563_062019",
                  "catalog_product_id": "MLA9652754",
                  "listing_type_id": "gold_special",
                  "permalink": "https://www.mercadolibre.com.ar/moto-g6-32-gb-indigo-oscuro-3-gb-ram/p/MLA9652754",
                  "buying_mode": "buy_it_now",
                  "site_id": "MLA",
                  "category_id": "MLA1055",
                  "domain_id": "MLA-CELLPHONES",
                  "thumbnail": "http://http2.mlstatic.com/D_632562-MLA31003470563_062019-I.jpg",
                  "currency_id": "ARS",
                  "order_backend": 1,
                  "price": 179600,
                  "original_price": null,
                  "sale_price": {},
                  "available_quantity": 1,
                  "official_store_id": null,
                  "use_thumbnail_id": true,
                  "accepts_mercadopago": true,
                  "shipping": {},
                  "stop_time": "2044-03-02T04:00:00.000Z",
                  "seller": {},
                  "attributes": [],
                  "installments": {},
                  "winner_item_id": null,
                  "catalog_listing": true,
                  "discounts": null,
                  "promotions": [
                  ],
                  "inventory_id": null
                }
              ]
            }
            """
        // Creamos un objeto `SearchModel` a partir de la cadena JSON simulada.
        let response = SearchModel(JSONString: jsonString)
        
        return response
    }
}

/// Clase de mock para la vista de búsqueda, implementando el protocolo `SearchViewProtocol`.
class MockSearchView: SearchViewProtocol {
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


/// Clase de mock para el enrutador de búsqueda, implementando el protocolo `SearchRouterProtocol`.
class MockSearchRouter: SearchRouterProtocol {
    /// Indica si el método `createModule()` fue llamado.
    var createModuleCalled = false
    /// Indica si el método `pushToListScreen(navigationController:result:)` fue llamado.
    var createPushCalled = false
    
    
    /**
        Método estático para crear un módulo de búsqueda.
        - Returns: Una instancia de `SearchViewController`
    */
    static func createModule() -> SearchViewController {
        MockSearchRouter().createModuleCalled = true
        return SearchViewController()
    }
    
    /**
     Método para navegar a la pantalla de lista.
     - Parameters:
        - navigationController: El controlador de navegación.
        - result: Los resultados de la búsqueda.
    */
    func pushToListScreen(navigationController: UINavigationController, result: SearchModel) {
        createPushCalled = true
    }
}


/// Clase de mock para el interactor de búsqueda, implementando el protocolo `SearchInteractorProtocol`.
class MockSearchInteractor: SearchInteractorProtocol {
    /// La referencia al presentador de búsqueda.
    var presenter: (any SearchPresenterViewProtocol)?
    
    /// Indica si el método `searchInfo(text:)` fue llamado.
    var responseSearchCalled = false
    
    /**
        Método del interactor que simula una búsqueda de información.
        
        - Parameter 
            - text: El texto de búsqueda.
    */
    func searchInfo(text: String) {
        responseSearchCalled = true
    }
}
