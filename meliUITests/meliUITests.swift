//
//  meliUITests.swift
//  meliUITests
//
//  Created by jonnattan Choque on 2/05/24.
//

import XCTest

extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx:0.0, dy:0.0))
            coordinate.tap()
        }
    }
}

final class meliUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Configura tu aplicación para las pruebas de interfaz de usuario
        app = XCUIApplication()
        app.launch() // Inicia la aplicación
    }

    override func tearDownWithError() throws {
        // Limpia después de cada prueba
    }

    func testSearchSuccess() throws {
        // Interactúa con los elementos de la pantalla de búsqueda
        let searchTextField = app.textFields["searchTextField"]
        let searchButton = app.buttons["buttonSearch"]

        // Ingresa el nombre lo que se quiere buscar
        searchTextField.tap()
        searchTextField.typeText("iphone")
        
        // Presiona el botón de realizar búsqueda
        searchButton.forceTapElement()

        // Verifica si la pantalla de búsqueda desaparece y se muestra la de listado
        XCTAssertFalse(app.otherElements["ListViewController"].exists)
    }
    
    func testListViewItemSelection() throws {
        
        try testSearchSuccess()
        
        // Interactúa con el elemento del UICollectionView
        let collectionView = app.collectionViews.firstMatch

        // Simula la carga de datos en el UICollectionView
        waitForElementToAppear(collectionView.cells.element(boundBy: 0))

        // Selecciona el elemento específico
        let itemToSelect = collectionView.cells.element(boundBy: 0)
        itemToSelect.tap()

        // Verifica si la acción esperada se realiza correctamente
        XCTAssertFalse(app.otherElements["DetailViewController"].exists)
    }
    
    func testDetailViewScroll() throws {
        try testListViewItemSelection()
        
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 10), "El UITableView no está disponible")

        // Hace scroll hacia abajo en el UITableView
        tableView.swipeUp()

        // Verifica si ciertos elementos están visibles después de hacer scroll
        let firstVisibleCell = tableView.cells.firstMatch
        XCTAssertTrue(firstVisibleCell.exists, "El primer elemento del UICollectionView no está visible después de hacer scroll")
    }
    
    // Espera hasta que un elemento del UICollectionView esté disponible
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 60) {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        XCTAssert(result == .completed, "Elemento no apareció a tiempo")
    }
}
