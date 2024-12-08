package crashing

import (
	"crypto/sha256"
	"testing"
)

func Test_Is_exist_coverage(t *testing.T) {
	// 미리 정의된 set 만들어놓기
	coverageSet := NewSet()

	testVal1 := []uint{1, 11, 1337}
	testVal2 := []uint{1, 143, 1337}
	testVal3 := []uint{9832, 10, 1337}

	testVal1ST := UintSliceToBytes(testVal1)
	testVal2ST := UintSliceToBytes(testVal2)
	testVal3ST := UintSliceToBytes(testVal3)

	exVal1Array := sha256.Sum256(testVal1ST)
	exVal2Array := sha256.Sum256(testVal2ST)
	exVal3Array := sha256.Sum256(testVal3ST)

	exVal1 := BytesToUint64(exVal1Array)
	exVal2 := BytesToUint64(exVal2Array)
	exVal3 := BytesToUint64(exVal3Array)

	coverageSet.Add(exVal1)
	coverageSet.Add(exVal2)
	coverageSet.Add(exVal3)

	// 테스트용 Val 생성
	testVal := []uint{1, 10, 1337}
	testValST := UintSliceToBytes(testVal)
	testValHashArray := sha256.Sum256(testValST)
	testValHash := BytesToUint64(testValHashArray)
	println(testValHash)

	// test
	println(coverageSet.Contains(testValHash))
}
