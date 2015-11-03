//
//  sqlite.hpp
//  TeaMenu
//
//  Created by Jan on 27.03.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#ifndef TeaMenu_sqlite_h
#define TeaMenu_sqlite_h

#include <sqlite3.h>
#include <vector>
#include <string>

// SQL statements
#define SQL_CREATE_TABLE   "CREATE TABLE IF NOT EXISTS Teas" \
                           "(Time INT  NOT NULL CHECK (Time > 0)," \
                           " Name TEXT NOT NULL)"
#define SQL_INSERT_TEA     "INSERT INTO Teas VALUES (?, ?)"
#define SQL_DELETE_TEAS    "DELETE FROM Teas"
#define SQL_READ_ALL_TEAS  "SELECT Time, Name FROM Teas"
#define SQL_DELETE_ONE_TEA "DELETE FROM Teas WHERE Name = ?"
#define SQL_COUNT_TEAS     "SELECT COUNT(*) AS TeaCount FROM Teas"

// C(++) struct for storing teas
struct teaNode {
	int minutes;
	std::string name;
};

// Function definitions
bool initDB(const char*);
bool prepareDB(void);
bool closeDB(void);
bool writeTea(int, const char*);
bool removeTea(const char*);
bool removeAllTeas(void);
bool readAllTeas(std::vector<teaNode>& nodeVector);
int countTeas(void);

#endif
