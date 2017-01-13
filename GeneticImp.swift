//
//  GeneticImp.swift
//  
//
//  Created by Chris Davis on 22/10/2016.
//
//

import Foundation

let mutationRate:Float = 0
let totalPopulation = 150
let target = "to be or not to be"
var targetLength = target.characters.count


struct DNA
{
    var genes:[Character]!
    var fitness:Float = 0
    
    init() {
        genes = [Character](repeating: " ", count:18)
        for i in 0..<18
        {
            genes[i] = Character(UnicodeScalar(arc4random_uniform(96) + 32)!)
        }
    }
    
    func crossover(partner:DNA) -> DNA
    {
        var child = DNA()
        let midpoint = Int(arc4random_uniform(18))
        for i in 0..<18
        {
            if i > midpoint
            {
                child.genes[i] = self.genes[i]
            } else {
                child.genes[i] = partner.genes[i]
            }
        }
        return child
    }
    
    mutating func mutate(mutationRate:Float)
    {
        for i in 0..<18
        {
            if (Float(arc4random()) / Float(UINT32_MAX)) < mutationRate
            {
                genes[i] = Character(UnicodeScalar(arc4random_uniform(96) + 32)!)
            }
        }
    }
    
    func toString() -> String
    {
        return String(genes)
    }
    
}


class World
{
    
    func fitness(dna:DNA) -> Float
    {
        var score:Int = 0
        for i in 0..<dna.genes.count
        {
            if dna.genes[i] == target[target.index(target.startIndex, offsetBy: i)]
            {
                score += 1
            }
        }
        return Float(score)/Float(target.characters.count)
    }
    
}


// Main
let world = World()
var population:[DNA] =  [DNA](repeating: DNA(), count:totalPopulation)

// Seed
for i in 0..<totalPopulation
{
    population[i] = DNA()
}


// loop
for loop in 0..<0
{
    
    for i in 0..<totalPopulation
    {
        population[i].fitness = world.fitness(dna: population[i])
    }
    
    var matingPool:[DNA] = [DNA]()
    for i in 0..<totalPopulation
    {
        let n = Int(population[i].fitness * 100)
        let bulk = [DNA](repeating: population[i], count:n)
        matingPool.append(contentsOf: bulk)
    }
    
    for i in 0..<totalPopulation
    {
        var a = Int(arc4random_uniform(UInt32(matingPool.count)))
        var b = Int(arc4random_uniform(UInt32(matingPool.count)))
        
        let partnerA = matingPool[a]
        let partnerB = matingPool[b]
        
        var child = partnerA.crossover(partner: partnerB)
        
        child.mutate(mutationRate: mutationRate)
        
        population[i] = child
    }
    
    print(population[0])
    
}
