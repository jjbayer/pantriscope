//
//  pantryTests.swift
//  pantryTests
//
//  Created by Joris on 19.08.20.
//  Copyright © 2020 Joris. All rights reserved.
//

import XCTest
@testable import pantry

class pantryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExpiryDateParser() throws {

        XCTAssertEqual(
            ExpiryDateParser().parse(text: "17.10.20").date,
            makeDate(2020, 10, 17)
        )

        XCTAssertEqual(
            ExpiryDateParser().parse(text: "010158").confidence, 0.0
        )

        XCTAssertEqual(
            ExpiryDateParser().parse(text: "31.12.5158").confidence, 0.0
        )
    }

    private func makeDate(_ year: Int, _ month: Int, _ day: Int) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"

        return formatter.date(from: "\(year)\(month)\(day)")!
    }

}
