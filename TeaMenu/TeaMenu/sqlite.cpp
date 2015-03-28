//
//  sqlite.cpp
//  TeaMenu
//
//  Created by Jan on 27.03.15.
//  Copyright (c) 2015 dfragment.net. All rights reserved.
//

#include <iostream>
#include <cstring>
#include "sqlite.hpp"

sqlite3 *db;

void sqliteLog(void*, const char*);

/* Initializes the database */
bool initDB(const char *path)
{
	if (path == NULL)
		return false;
	bool initOkay = (sqlite3_open(path, &db) == SQLITE_OK);
#ifdef DEBUG
	sqlite3_trace(db, sqliteLog, NULL);
#endif
	return initOkay;
}

/* Creates all necessary structures in the database */
bool prepareDB()
{
	return (sqlite3_exec(db, SQL_CREATE_TABLE, 0, 0, NULL) == SQLITE_OK);
}

/* Closes the database */
bool closeDB(void)
{
	// Closing NULL is a no-op according to the docs
	return (sqlite3_close(db) == SQLITE_OK);
}

/* Inserts a single tea entity into the database */
bool writeTea(int time, const char *name)
{
	sqlite3_stmt *stmt;
	int retVal = 0;
	if ((sqlite3_prepare(db, SQL_INSERT_TEA, -1, &stmt, 0) == SQLITE_OK)
		&& (sqlite3_bind_int(stmt, 1, time) == SQLITE_OK)
		&& (sqlite3_bind_text(stmt, 2, name, (int)strlen(name), SQLITE_STATIC) == SQLITE_OK)
		&& (sqlite3_step(stmt) == SQLITE_DONE)) {
		retVal = 1;
	}
	sqlite3_finalize(stmt);
	return retVal;
}

/* Removes a single tea by its name */
bool removeTea(const char *name)
{
	sqlite3_stmt *stmt;
	int retVal = 0;
	if ((sqlite3_prepare(db, SQL_DELETE_ONE_TEA, -1, &stmt, 0) == SQLITE_OK)
		&& (sqlite3_bind_text(stmt, 1, name, (int)strlen(name), SQLITE_STATIC) == SQLITE_OK)
		&& (sqlite3_step(stmt) == SQLITE_DONE)) {
		retVal = 1;
	}
	sqlite3_finalize(stmt);
	return retVal;
}

/* Removes all teas from the database */
bool removeAllTeas(void)
{
	return (sqlite3_exec(db, SQL_DELETE_TEAS, 0, 0, NULL) == SQLITE_OK);
}

/* Counts the number of entries in the Teas table */
int countTeas(void)
{
	sqlite3_stmt *stmt;
	int rowCount = 0;
	if ((sqlite3_prepare(db, SQL_COUNT_TEAS, -1, &stmt, 0) == SQLITE_OK)
		&& (sqlite3_step(stmt) == SQLITE_ROW)) {
		// We ignore all subsequent rows -- the next one is SQLITE_DONE anyway.
		rowCount = sqlite3_column_int(stmt, 0);
	}
	return rowCount;
}

bool readAllTeas(std::vector<teaNode>& nodeVector)
{
	sqlite3_stmt *stmt;
	if (sqlite3_prepare(db, SQL_READ_ALL_TEAS, -1, &stmt, 0) == SQLITE_OK) {
		while (sqlite3_step(stmt) == SQLITE_ROW) {
			// Get the data of the current row
			int rMinutes = sqlite3_column_int(stmt, 0);
			const char *ccName = (const char *) sqlite3_column_text(stmt, 1);
			std::string rName = std::string(ccName, strlen(ccName));
			// New node; add to vector
			teaNode cNode = { .minutes = rMinutes, .name = rName };
			nodeVector.push_back(cNode);
		}
		sqlite3_finalize(stmt);
		return true;
	}
	return false;
}

/* Logs all SQL queries to stderr in Debug builds */
void sqliteLog(void* v, const char* c)
{
#ifdef DEBUG
	std::cerr << "[tea-sql] " << c << std::endl;
#endif
}
