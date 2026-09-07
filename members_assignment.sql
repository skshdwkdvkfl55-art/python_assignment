-- ==============================================================================
-- [AX 2회차 SQL & 데이터베이스 과제]
-- 파일명: members_assignment.sql
-- 내용: PostgreSQL Schema/Table 생성, CRUD 및 집계 분석
-- ==============================================================================

-- ==============================================================================
-- Part 1. PostgreSQL Schema와 Table 만들기
-- ==============================================================================

-- 1. practice 스키마 생성
CREATE SCHEMA IF NOT EXISTS practice;

-- (테이블이 이미 있을 경우를 대비한 초기화)
DROP TABLE IF EXISTS practice.members;

-- 2. practice.members 테이블 생성
CREATE TABLE practice.members (
    member_id SERIAL PRIMARY KEY,        -- 회원 고유번호 (자동 증가 기본키)
    name VARCHAR(50) NOT NULL,           -- 회원 이름
    email VARCHAR(100) UNIQUE NOT NULL,  -- 이메일 (중복 불가 고유값)
    age INTEGER,                         -- 나이
    joined_at DATE                       -- 가입일
);

-- 테이블 생성 확인
SELECT * FROM practice.members;


-- ==============================================================================
-- Part 2. INSERT와 SELECT로 회원 데이터 관리하기
-- ==============================================================================

-- 1. 최소 5명의 회원 데이터 입력
INSERT INTO practice.members (name, email, age, joined_at)
VALUES
    ('김민수', 'minsu@example.com', 25, '2026-08-01'),
    ('이영희', 'younghee@example.com', 28, '2026-08-05'),
    ('박철수', 'chulsoo@example.com', 22, '2026-08-10'),
    ('최지우', 'jiwoo@example.com', 35, '2026-08-15'),
    ('정다은', 'daeun@example.com', 24, '2026-08-20');

-- 2-1. 전체 회원 조회
SELECT * FROM practice.members;

-- 2-2. 이름과 이메일만 조회
SELECT name, email 
FROM practice.members;

-- 2-3. 25세 이상 회원 조회
SELECT * 
FROM practice.members 
WHERE age >= 25;

-- 2-4. 특정 이름('김민수')의 회원 조회
SELECT * 
FROM practice.members 
WHERE name = '김민수';

-- 2-5. 나이가 많은 순서(내림차순)로 조회
SELECT * 
FROM practice.members 
ORDER BY age DESC;

-- 2-6. 가입일 순서(오름차순)로 조회
SELECT * 
FROM practice.members 
ORDER BY joined_at ASC;


-- ==============================================================================
-- Part 3. UPDATE와 DELETE로 데이터 변경하기
-- ==============================================================================

-- 1. 1번 회원(김민수)의 나이를 30세로 수정
UPDATE practice.members
SET age = 30
WHERE member_id = 1;

-- 수정 결과 확인
SELECT * FROM practice.members WHERE member_id = 1;

-- 2. 5번 회원(정다은) 삭제
DELETE FROM practice.members
WHERE member_id = 5;

-- 삭제 후 전체 회원 조회 (5번 회원이 삭제되어 총 4명인지 확인)
SELECT * FROM practice.members ORDER BY member_id;


-- ==============================================================================
-- Part 4. 집계 함수를 이용한 회원 데이터 분석
-- ==============================================================================

-- 1. 전체 회원 수, 평균 나이, 최고 나이, 최저 나이 종합 조회
SELECT 
    COUNT(*) AS total_members,
    ROUND(AVG(age), 1) AS avg_age,
    MAX(age) AS max_age,
    MIN(age) AS min_age
FROM practice.members;

-- 2. 25세 이상인 회원 수 집계
SELECT COUNT(*) AS members_over_25
FROM practice.members
WHERE age >= 25;


-- ==============================================================================
-- [도전 문제] 고급 SQL 조회
-- ==============================================================================

-- 1. 연령대별(20대, 30대 등) 회원 수 조회
SELECT 
    CASE 
        WHEN age >= 30 THEN '30대 이상'
        WHEN age >= 20 THEN '20대'
        ELSE '기타'
    END AS age_group,
    COUNT(*) AS member_count
FROM practice.members
GROUP BY 
    CASE 
        WHEN age >= 30 THEN '30대 이상'
        WHEN age >= 20 THEN '20대'
        ELSE '기타'
    END;

-- 2. 가장 최근에 가입한 회원 1명 조회
SELECT * 
FROM practice.members 
ORDER BY joined_at DESC 
LIMIT 1;

-- 3. 회원들의 평균 나이보다 나이가 많은 회원 조회 (서브쿼리 활용)
SELECT * 
FROM practice.members 
WHERE age > (SELECT AVG(age) FROM practice.members);

-- 4. 특정 도메인(@example.com) 이메일을 사용하는 회원 검색
SELECT * 
FROM practice.members 
WHERE email LIKE '%@example.com';

1. PRIMARY KEY는 왜 필요한가요?
- 테이블 안에서 각각의 데이터 행(레코드)을 중복 없이 고유하게 
식별하기 위해 필요하며, 데이터의 무결성을 지키고 UPDATE나 DELETE 시 정확한 대상을 지정할 수 있게 해줍니다.

2. WHERE 없이 UPDATE 또는 DELETE를 실행하면 어떤 문제가 발생할 수 있나요?
- 대상 조건이 없으므로 테이블의 모든 행(전체 데이터)이 한꺼번에 수정되거나 영구 삭제되는 치명적인 데이터 사고가 발생합니다.

3. SELECT *와 필요한 컬럼만 선택하는 SQL의 차이는 무엇인가요?
- SELECT *는 모든 열을 다 가져오므로 네트워크 트래픽과 메모리를 낭비할 수 있지만, 필요한 컬럼만 명시하면 데이터베이스 처리 성능이 대폭 향상되고 코드가 명확해집니다.

4. COUNT()와 AVG()는 각각 어떤 값을 계산하나요?
- COUNT()는 조건을 만족하는 행(데이터 건수)의 총개수를 세고, AVG()는 숫자 컬럼 값들의 산술 평균을 계산합니다.

5. Python에서 데이터를 처리하는 것과 DB에서 SQL로 데이터를 조회하는 것의 차이를 어떻게 이해했나요?
- Python은 데이터를 메모리로 가져와 반복문(for)과 조건문으로 직접 처리하지만, SQL은 수백만 건의 대용량 데이터가 저장된 데이터베이스 서버 엔진 레벨에서 필터링, 정렬, 집계를 초고속으로 처리한 결과만 클라이언트에 전달한다는 차이가 있습니다.