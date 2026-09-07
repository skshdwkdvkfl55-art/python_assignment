# ==============================================================================
# [AX 2회차 Python 기초 과제]
# 파일명: python_assignment.py
# ==============================================================================

# ==============================================================================
# Part 1. 리스트와 반복문을 이용한 데이터 처리
# ==============================================================================
print("\n" + "="*50)
print("[Part 1] 리스트와 반복문(for/if)을 이용한 데이터 처리")
print("="*50)

# 1. 숫자 리스트 생성
scores = [85, 92, 58, 76, 95, 64, 88, 50]
print("원본 점수 리스트:", scores)

# 2. for문과 if문으로 80점 이상인 우수 점수 개수 및 데이터 찾기
high_scores = []
count_high_scores = 0

for score in scores:
    if score >= 80:
        high_scores.append(score)
        count_high_scores += 1

print(f"80점 이상 점수 목록: {high_scores}")
print(f"80점 이상 학생 수: {count_high_scores}명")


# ==============================================================================
# Part 2. 딕셔너리를 이용한 단어 빈도 분석
# ==============================================================================
print("\n" + "="*50)
print("[Part 2] 딕셔너리를 이용한 단어 빈도 분석")
print("="*50)

sentence = """
파이썬 공부는 재미있다
파이썬 공부는 어렵지만 재미있다
데이터 분석에도 파이썬을 사용한다
파이썬 공부를 계속하면 실력이 늘어난다
"""

# 1. split()으로 단어 단위 분리
words = sentence.split()
print("분리된 단어 목록:", words)

# 2. 빈 딕셔너리 생성 후 for/if문으로 빈도수 집계 (Counter 미사용)
word_counts = {}
for word in words:
    if word not in word_counts:
        word_counts[word] = 1        # 처음 등장
    else:
        word_counts[word] += 1       # 기존 등장 횟수 + 1

# 3. 전체 단어와 등장 횟수 출력
print("\n[전체 단어 등장 횟수]")
for word, count in word_counts.items():
    print(f"{word} : {count}회")

# 4. 2회 이상 등장한 단어만 별도 출력
print("\n[2회 이상 등장한 주요 단어]")
for word, count in word_counts.items():
    if count >= 2:
        print(f"★ {word} : {count}회")


# ==============================================================================
# Part 3. 함수로 반복되는 코드 정리하기
# ==============================================================================
print("\n" + "="*50)
print("[Part 3] 함수(def)로 반복되는 코드 정리하기")
print("="*50)

def count_words(text: str) -> dict:
    """문자열을 입력받아 단어별 빈도수를 딕셔너리로 반환하는 함수"""
    if not isinstance(text, str):
        raise TypeError("입력값은 반드시 문자열이어야 합니다.")
        
    w_list = text.split()
    counts = {}
    for w in w_list:
        if w not in counts:
            counts[w] = 1
        else:
            counts[w] += 1
    return counts

def filter_words(counts: dict, min_limit: int = 2) -> dict:
    """특정 횟수 이상 등장한 단어만 필터링하여 반환하는 함수"""
    return {w: c for w, c in counts.items() if c >= min_limit}

# 함수 호출 및 결과 출력
analyzed_result = count_words(sentence)
filtered_result = filter_words(analyzed_result, min_limit=2)

print("함수 호출 결과 (단어 빈도):", analyzed_result)
print("함수 호출 결과 (2회 이상 필터링):", filtered_result)


# ==============================================================================
# Part 4. 오류 확인 및 코드 검증 (try-except)
# ==============================================================================
print("\n" + "="*50)
print("[Part 4] 오류 확인 및 예외 처리 검증")
print("="*50)

# 정상 호출 테스트
try:
    test_result = count_words("파이썬 코딩 파이썬 실습")
    print(" 정상 입력 테스트 성공:", test_result)
except Exception as e:
    print(" 오류 발생:", e)

# 비정상 입력(숫자 입력) 테스트로 예외 처리 검증
try:
    print("\n[비정상 입력(숫자) 전달 시도]")
    count_words(12345)
except TypeError as e:
    print(f" 예외 방어 성공 (TypeError 감지): {e}")


# ==============================================================================
# [도전 문제] 추가 분석 기능 (최빈 단어 / 최저 빈도 / 파일 저장)
# ==============================================================================
print("\n" + "="*50)
print("[도전 문제] 최빈/최저 빈도 단어 찾기 & 파일 저장")
print("="*50)

# 1. 가장 많이 등장한 단어 찾기
max_word = max(analyzed_result, key=analyzed_result.get)
print(f" 가장 많이 등장한 단어: '{max_word}' ({analyzed_result[max_word]}회)")

# 2. 가장 적게 등장한 단어(1회) 찾기
min_words = [w for w, c in analyzed_result.items() if c == 1]
print(f" 1회만 등장한 단어들: {min_words}")

# 3. 분석 결과 파일로 저장하기
filename = "word_analysis_result.txt"
with open(filename, "w", encoding="utf-8") as f:
    f.write("=== 단어 빈도 분석 최종 보고서 ===\n")
    for w, c in analyzed_result.items():
        f.write(f"{w} : {c}회\n")
    f.write(f"\n가장 많이 등장한 단어: {max_word} ({analyzed_result[max_word]}회)\n")

print(f" 파일 저장 완료: '{filename}'")
print("="*50)

