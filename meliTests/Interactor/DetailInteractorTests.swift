//
//  DetailInteractorTests.swift
//  meliTests
//
//  Created by jonnattan Choque on 6/05/24.
//

import XCTest
import Alamofire
@testable import meli

class DetailInteractorTests: XCTestCase {
    
    var interactor: DetailInteractor!
    var mockPresenter: MockDetailPresenter!
    
    /**
        Configura el entorno necesario antes de cada prueba.

        - Prepara la instancia simulada para el presenter.
        - Configura el interactor con la instancias simulada correspondiente.
    */
    override func setUp() {
        super.setUp()
        mockPresenter = MockDetailPresenter()
        
        interactor = DetailInteractor()
        interactor.presenter = mockPresenter
    }
    
    /**
        Realiza la limpieza después de cada prueba.

        - Libera las instancias simuladas del interactor y el presentador.
    */
    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        super.tearDown()
    }
    
    /**
        Verifica si el método `detailInfoSuccess` es un caso exitoso de obtención del detalle

        - Given:
            - Definimos el ID y la URL del detalle, así como el JSON de respuesta.
            - Convertimos la cadena JSON en datos para usarla como respuesta simulada.
            - Configuramos la respuesta simulada con un código de estado 200 y los datos JSON.
        - When: Llamamos al método `detailInfo(id:)` del interactor con el ID dado.
        - Then: Después de un segundo (para permitir que se complete la solicitud), verificamos si el método `detailFetchedSuccess(results:seller:)` del presenter fue llamado.
    */
    func testDetailInfoSuccess() {
        // Given
        let id = "123"
        let url = URL(string: Constants.endpointDetails.appending(id))!
        let jsonString = """
            {
                "id": "123",
                // Otras propiedades del modelo de detalle aquí...
            }
        """
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("No se pudo convertir la cadena JSON en datos")
            return
        }
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.mockResponse = (response, jsonData)
        
        // When
        interactor.detailInfo(id: id)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.mockPresenter.didCallDetailFetchedSuccess)
        }
    }
    
    /**
        Verifica si el método `detailInfoEmpty`no se encontro el detalle.

         - Given:
             - Definimos un ID y una URL de detalle, así como un JSON de respuesta con un ID vacío.
             - Convertimos la cadena JSON en datos para usarla como respuesta simulada.
             - Configuramos la respuesta simulada con un código de estado 200 y los datos JSON.
         - When: Llamamos al método `detailInfo(id:)` del interactor con el ID dado.
         - Then: Después de un segundo (para permitir que se complete la solicitud), verificamos si el método `detailFetchEmpty` del presenter fue llamado.
    */
    func testDetailInfoEmpty() {
        // Given
        let id = "12345678905231343"
        let url = URL(string: Constants.endpointDetails.appending(id))!
        let jsonString = """
            {
                "id": ""
            }
        """
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("No se pudo convertir la cadena JSON en datos")
            return
        }
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.mockResponse = (response, jsonData)
        
        // When
        interactor.detailInfo(id: id)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.mockPresenter.didCallDetailFetchEmpty)
        }
    }
    
    /**
        Verifica si el método `detailInfoFailure`fallo al consultar el detalle

         - Given:
             - Definimos un ID y una URL de detalle, así como una respuesta simulada con un código de estado 500 (error del servidor).
             - Configuramos la respuesta simulada con un código de estado 500 y sin datos.
         - When: Llamamos al método `detailInfo(id:)` del interactor con el ID dado.
         - Then: Después de un segundo (para permitir que se complete la solicitud), verificamos si el método `detailFetchFailed` del presenter fue llamado.
    */
    func testDetailInfoFailure() {
        // Given
        // Preparación:
        let id = "123"
        let url = URL(string: Constants.endpointDetails.appending(id))!
        let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.mockResponse = (response, Data())
        
        // When
        interactor.detailInfo(id: id)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.mockPresenter.didCallDetailFetchFailed)
        }
    }

}

/// Clase de mock para el presenter de detalle, implementando el protocolo `DetailPresenterViewProtocol`.
class MockDetailPresenter: DetailPresenterViewProtocol {
    /// Indica si el método `detailFetchedSuccess(results:seller:)` fue llamado.
    var didCallDetailFetchedSuccess = false
    
    /// Indica si el método `detailFetchEmpty()` fue llamado.
    var didCallDetailFetchEmpty = false
    
    /// Indica si el método `detailFetchFailed()` fue llamado.
    var didCallDetailFetchFailed = false
    
    /**
        Simula el método del presenter que se llama cuando se obtienen detalles exitosamente.
        - Parameters:
            - results: El modelo del detalle obtenido.
            - seller: El modelo de seller relacionado con el detalle.
    */
    func detailFetchedSuccess(results: DetailModel, seller: SellerModel) {
        didCallDetailFetchedSuccess = true
    }
    
    /// Simula el método del presenter que se llama cuando no se encontraron detalles.
    func detailFetchEmpty() {
        didCallDetailFetchEmpty = true
    }
    
    /// Simula el método del presenter que se llama cuando la obtención de detalles falló.
    func detailFetchFailed() {
        didCallDetailFetchFailed = true
    }
}
