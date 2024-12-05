package crashing

import (
	"crypto/chacha20/rand"
	"encoding/binary"
	"math"
	"time"
)

type Result struct{}

type Seed struct {
	Gen     uint
	IsUsed  bool
	Content string
	Result  Result
}

// 시드 생성 헬퍼 함수
func makeTimeSeed() []byte {
	seed := make([]byte, 32)
	binary.LittleEndian.PutUint64(seed, uint64(time.Now().UnixNano()))
	return seed
}

// 교배를 위한 함수
func Crossover(parent1, parent2 *Seed) *Seed {
	if len(parent1.Content) != len(parent2.Content) {
		return nil
	}

	rng := rand.NewFromSeed(makeTimeSeed())
	crossPoint := rng.Intn(len(parent1.Content))

	newContent := parent1.Content[:crossPoint] + parent2.Content[crossPoint:]

	return &Seed{
		Gen:     parent1.Gen + 1,
		Content: newContent,
		IsUsed:  false,
	}
}

// mutation을 위한 함수
func Mutate(seed *Seed) *Seed {
	content := []rune(seed.Content)
	mutationRate := 1.0 / float64(seed.Gen*seed.Gen)

	rng := rand.NewFromSeed(makeTimeSeed())

	for i := range content {
		if float64(rng.Uint64n(100))/100.0 < mutationRate {
			content[i] = rune(rng.Intn(26) + 'a')
		}
	}

	return &Seed{
		Gen:     seed.Gen + 1,
		Content: string(content),
		IsUsed:  false,
	}
}

func Evolve(seeds []Seed) []Seed {
	n := len(seeds)
	if n < 2 {
		return seeds
	}

	// 결과를 저장할 슬라이스
	offspring := make([]Seed, 0)

	// 섞기
	rng := rand.NewFromSeed(makeTimeSeed())
	rng.Shuffle(n, func(i, j int) {
		seeds[i], seeds[j] = seeds[j], seeds[i]
	})

	// 교배
	for i := 0; i < n-1; i += 2 {
		child := Crossover(&seeds[i], &seeds[i+1])
		if child != nil {
			offspring = append(offspring, *child)
		}
	}

	if len(offspring) == 0 {
		return seeds
	}

	// 현재 세대 기준으로 mutation으로 생성할 자식 수 계산
	currGen := offspring[0].Gen
	mutationCount := int(120.0 / math.Pow(float64(currGen), 2))

	// 최소 1개의 mutation 보장
	if mutationCount < 1 {
		mutationCount = 1
	}

	// mutation으로 추가 자식 생성
	mutatedOffspring := make([]Seed, 0, mutationCount)
	for i := 0; i < mutationCount; i++ {
		// 새로 생성된 자식들 중에서 랜덤하게 선택
		parentIdx := rng.Intn(len(offspring))
		mutated := Mutate(&offspring[parentIdx])
		mutatedOffspring = append(mutatedOffspring, *mutated)
	}

	// 기존 자식들과 mutation된 자식들을 합침
	offspring = append(offspring, mutatedOffspring...)

	return offspring
}

func TestEvolve(initialSeeds []Seed, generations int) [][]Seed {
	results := make([][]Seed, generations)
	currentGen := initialSeeds

	for i := 0; i < generations; i++ {
		currentGen = Evolve(currentGen)
		results[i] = currentGen
	}

	return results
}
