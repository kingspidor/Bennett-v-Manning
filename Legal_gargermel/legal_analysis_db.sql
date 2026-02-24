-- 1. Jurisdictions/Venues (Superior Court, Court of Appeals, etc.)
CREATE TABLE venues (
    venue_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    division VARCHAR(50),
    location VARCHAR(255)
) ENGINE=InnoDB;

-- 2. Master Case List (Maps to Court_Cases/ directory)
CREATE TABLE cases (
    case_id INT AUTO_INCREMENT PRIMARY KEY,
    case_number VARCHAR(50) UNIQUE NOT NULL,
    case_title VARCHAR(255) NOT NULL,
    venue_id INT,
    filing_date DATE,
    status ENUM('Active', 'Closed', 'On Appeal', 'Dismissed') DEFAULT 'Active',
    FOREIGN KEY (venue_id) REFERENCES venues(venue_id)
) ENGINE=InnoDB;

-- 3. Parties Involved (Parties in Master Evidence Distill)
CREATE TABLE parties (
    party_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    role ENUM('Appellant', 'Respondent', 'Petitioner', 'Subject Child', 'Counsel', 'Third Party'),
    description TEXT
) ENGINE=InnoDB;

-- 4. Documents & Filings (Physical files in the repo)
CREATE TABLE documents (
    doc_id INT AUTO_INCREMENT PRIMARY KEY,
    case_id INT,
    filed_by_party_id INT,
    file_path VARCHAR(512) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    category ENUM('Motion', 'Order', 'Brief', 'Petition', 'Record', 'Correspondence', 'Exhibit'),
    filing_date DATE,
    summary TEXT,
    is_extra_record BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (case_id) REFERENCES cases(case_id),
    FOREIGN KEY (filed_by_party_id) REFERENCES parties(party_id)
) ENGINE=InnoDB;

-- 5. Legal Errors & Violations (Your requested error list)
CREATE TABLE reversible_errors (
    error_id INT AUTO_INCREMENT PRIMARY KEY,
    error_type ENUM('Due Process', 'Res Judicata', 'Collateral Estoppel', 'Fraud on Court', 'CR 56 Violation', 'RAP 15.2 Violation', 'Factual Error'),
    description TEXT NOT NULL,
    statutory_basis VARCHAR(100),
    severity ENUM('Manifest', 'Reversible', 'Harmless') DEFAULT 'Reversible'
) ENGINE=InnoDB;

-- 6. Error-to-Document Mapping (Links specific filings to specific errors)
CREATE TABLE document_error_mapping (
    mapping_id INT AUTO_INCREMENT PRIMARY KEY,
    doc_id INT,
    error_id INT,
    citation_details VARCHAR(255),
    FOREIGN KEY (doc_id) REFERENCES documents(doc_id) ON DELETE CASCADE,
    FOREIGN KEY (error_id) REFERENCES reversible_errors(error_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 7. Evidence & Exhibits (Maps to Discovery_and_Evidence/)
CREATE TABLE evidence_items (
    evidence_id INT AUTO_INCREMENT PRIMARY KEY,
    doc_id INT,
    evidence_type ENUM('Transcript', 'Email', 'Messenger Log', 'Video', 'Photo', 'Declaration'),
    event_date DATE,
    impeachment_target TEXT,
    FOREIGN KEY (doc_id) REFERENCES documents(doc_id)
) ENGINE=InnoDB;

-- 8. Key Quotes & Excerpts (Maps to excerpts.txt)
CREATE TABLE excerpts (
    excerpt_id INT AUTO_INCREMENT PRIMARY KEY,
    doc_id INT,
    speaker_party_id INT,
    content TEXT NOT NULL,
    timestamp_mark VARCHAR(50),
    FOREIGN KEY (doc_id) REFERENCES documents(doc_id),
    FOREIGN KEY (speaker_party_id) REFERENCES parties(party_id)
) ENGINE=InnoDB;
