package crashing

import (
	"crypto/sha256"
	"strconv"
	"strings"
)

// Coverage 타입 정의
type Coverage []uint

// Set 구조체 정의 (uint64 전용)
type Set struct {
	data map[uint64]struct{}
}

// Set 생성자
func NewSet() *Set {
	return &Set{
		data: make(map[uint64]struct{}),
	}
}

// Set 메서드들
func (s *Set) Add(element uint64) {
	s.data[element] = struct{}{}
}

func (s *Set) Remove(element uint64) {
	delete(s.data, element)
}

func (s *Set) Contains(element uint64) bool {
	_, exists := s.data[element]
	return exists
}

func (s *Set) Size() int {
	return len(s.data)
}

// uint 슬라이스를 문자열로 변환-deprecated
func UintToString(nums []uint) string {
	if len(nums) == 0 {
		return ""
	}

	var builder strings.Builder
	builder.WriteString(strconv.FormatUint(uint64(nums[0]), 10))

	for _, num := range nums[1:] {
		builder.WriteByte(' ')
		builder.WriteString(strconv.FormatUint(uint64(num), 10))
	}

	return builder.String()
}

func UintSliceToBytes(uints []uint) []byte {
	result := make([]byte, len(uints)*8) // uint 하나당 8바이트

	for i, num := range uints {
		// uint 값을 8개의 byte로 변환
		for j := 0; j < 8; j++ {
			result[i*8+j] = byte(num >> uint(56-j*8))
		}
	}

	return result
}

// sha256이 uint8 32개 를 반환해서,,,
func BytesToUint64(b [32]uint8) uint64 {
	return uint64(b[0])<<56 | uint64(b[1])<<48 | uint64(b[2])<<40 | uint64(b[3])<<32 |
		uint64(b[4])<<24 | uint64(b[5])<<16 | uint64(b[6])<<8 | uint64(b[7])
}

// UseSum64String 함수 정의
// func UseSum64String(stVal string) uint64

//{
//	var result uint64
//	for _, char := range stVal {
//		result = result*31 + uint64(char)
//	}
//	return result
//	} //?? 이거 왜 이렇게 적혀있음 아 테스트용으로 해놨구나
