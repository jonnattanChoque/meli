//
//  SearchInteractorTests.swift
//  meliTests
//
//  Created by jonnattan Choque on 7/05/24.
//

import XCTest
@testable import meli

final class SearchInteractorTests: XCTestCase {

    var interactor: SearchInteractor!
    var mockPresenter: MockSearchPresenter!

    /**
        Configura el entorno necesario antes de cada prueba.

        - Prepara la instancia simulada para el presenter.
        - Configura el interactor con la instancias simulada correspondiente.
    */
    override func setUp() {
        super.setUp()
        mockPresenter = MockSearchPresenter()
        
        interactor = SearchInteractor()
        interactor.presenter = mockPresenter
    }

    /**
        Realiza la limpieza después de cada prueba.

        - Libera las instancias simuladas del interactor y el presentador.
    */
    override func tearDown() {
        mockPresenter = nil
        interactor = nil
        super.tearDown()
    }
    
    /**
        Verifica si el método `searchInfoSuccess` es un caso exitoso de búsqueda

        - Given:
            - Definimos el texto de búsqueda, la URL de búsqueda y el JSON de respuesta con resultados de válidos.
            - Convertimos la cadena JSON en datos para usarla como respuesta simulada.
            - Configuramos la respuesta simulada con un código de estado 200 y los datos JSON.
        - When: Llamamos al método `searchInfo(text:)` del interactor con el texto de búsqueda dado.
        - Then: Después de un segundo (para permitir que se complete la solicitud), verificamos si el método `searchFetchedSuccess(results:)` del presenter fue llamado.
    */
    func testSearchInfoSuccess() {
        // Given
        let searchText = "iphone"
        let url = URL(string: Constants.endpointSearch.appending(searchText))!
        let jsonString = """
            {
                "results": [
                    // Los resultados de búsqueda se simulan como un JSON vacío en este caso.
                ]
            }
        """
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("No se pudo convertir la cadena JSON en datos")
            return
        }
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.mockResponse = (response, jsonData)
        
        // When
        interactor.searchInfo(text: searchText)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.mockPresenter.didCallSearchFetchedSuccess)
        }
    }
    
    /**
        Verifica si el método `searchInfoEmpty` es un caso exitoso de búsqueda

        - Given:
            - Definimos el texto de búsqueda, la URL de búsqueda y el JSON de respuesta con resultados de búsqueda vacíos.
            - Convertimos la cadena JSON en datos para usarla como respuesta simulada.
            - Configuramos la respuesta simulada con un código de estado 200 y los datos JSON.
        - When: Llamamos al método `searchInfo(text:)` del interactor con el texto de búsqueda dado.
        - Then: Después de un segundo (para permitir que se complete la solicitud), verificamos si el método `searchFetchEmpty` del presenter fue llamado.
    */
    func testSearchInfoEmpty() {
        // Given
        let searchText = "TestQuery"
        let url = URL(string: Constants.endpointSearch.appending(searchText))!
        let jsonString = """
            {
                "results": []
            }
        """
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("No se pudo convertir la cadena JSON en datos")
            return
        }
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.mockResponse = (response, jsonData)
        
        // When
        interactor.searchInfo(text: searchText)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.mockPresenter.didCallSearchFetchEmpty)
        }
    }

    /**
        Verifica si el método `searchInfoFailure` es un caso exitoso de búsqueda

        - Given:
            - Definimos el texto de búsqueda y la URL de búsqueda con un error simulado (código de estado 500).
            - Configuramos la respuesta simulada con un código de estado 500 y sin datos.
        - When: Llamamos al método `searchInfo(text:)` del interactor con el texto de búsqueda dado.
        - Then: Después de un segundo (para permitir que se complete la solicitud), verificamos si el método `searchFetchFailed` del presenter fue llamado.
    */
    func testSearchInfoFailure() {
        // Given
        let searchText = "/query/testQuery"
        let url = URL(string: Constants.endpointSearch.appending(searchText))!
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.mockResponse = (response, Data())
        
        // When
        interactor.searchInfo(text: searchText)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.mockPresenter.didCallSearchFetchFailed)
        }
    }
}

/// Clase de mock para el presenter de búsqueda, implementando el protocolo `SearchPresenterViewProtocol`.
class MockSearchPresenter: SearchPresenterViewProtocol {
    /// Indica si el método `searchFetchedSuccess(results:)` fue llamado.
    var didCallSearchFetchedSuccess = false
    
    /// Indica si el método `searchFetchEmpty()` fue llamado.
    var didCallSearchFetchEmpty = false
    
    /// Indica si el método `searchFetchFailed()` fue llamado.
    var didCallSearchFetchFailed = false
    
    /**
        Simula el método del presenter que se llama cuando se obtienen resultados de búsqueda exitosamente.
        - Parameters:
            - results: El modelo de resultados de búsqueda obtenido.
    */
    func searchFetchedSuccess(results: SearchModel) {
        didCallSearchFetchedSuccess = true
    }
    
    /// Simula el método del presenter que se llama cuando no se encontraron resultados de búsqueda.
    func searchFetchEmpty() {
        didCallSearchFetchEmpty = true
    }
    
    /// Simula el método del presenter que se llama cuando la búsqueda de información falló.
    func searchFetchFailed() {
        didCallSearchFetchFailed = true
    }
}
