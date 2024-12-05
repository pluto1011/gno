package crashing

import "testing"

func TestEvolve(t *testing.T) {
	parent1 := Seed{Gen: 1, IsUsed: true, Content: "hello"}
	parent2 := Seed{Gen: 1, IsUsed: true, Content: "world"}
	parent3 := Seed{Gen: 1, IsUsed: true, Content: "hi"}
	parent4 := Seed{Gen: 1, IsUsed: true, Content: "Belloo"}

	seeds := make([]Seed, 4)
	seeds[0] = parent1
	seeds[1] = parent2
	seeds[2] = parent3
	seeds[3] = parent4

	result := Evolve(seeds)
}
