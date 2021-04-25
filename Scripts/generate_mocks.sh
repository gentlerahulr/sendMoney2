#!/bin/sh

# Define output file. Change "${PROJECT_DIR}/${PROJECT_NAME}Tests" to your test's root source folder, if it's not the default name.
OUTPUT_FILE="${PROJECT_DIR}/${PROJECT_NAME}Tests/GeneratedMocks.swift"
echo "Generated Mocks File = ${OUTPUT_FILE}"

# Generate mock files
find . \
-name "TransactionListViewModel.swift" -or \
-path '*/Services/*.swift' -or \
-path '*/Managers/*.swift' \
| sed "s/$/ /" | xargs \
"${PODS_ROOT}/Cuckoo/run" generate --testable "ONZ" --output "${OUTPUT_FILE}"
