//
//  GeneticImp.swift
//
//
//  Created by Chris Davis on 22/10/2016.
//
//

import Foundation

public let mutationRate:Float = 0.01
public let totalPopulation = 300
//public let target = "to be or not to be"
public let target = "Chris Davis is a bad ass"
public var targetLength:Int = 0

public struct DNA
{
    var genes:[Character]!
    var fitness:Float = 0
    
    init() {
        genes = [Character](repeating: " ", count:target.characters.count)
        for i in 0..<target.characters.count
        {
            genes[i] = Character(UnicodeScalar(arc4random_uniform(96) + 32)!)
        }
        
        //print(toString())
    }
    
    func crossover(partner:DNA) -> DNA
    {
        var child = DNA()
        let midpoint = Int(arc4random_uniform(UInt32(genes.count)))
        for i in 0..<genes.count
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
        for i in 0..<genes.count
        {
            let r = (Float(arc4random()) / Float(UINT32_MAX))
            //print("\(r)")
            if r < mutationRate
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


public class World
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

public class GeneticImp
{

    public init() {
        targetLength = target.characters.count
    }

    public func main()
    {
        
        // Main
        let world = World()
        var population:[DNA] =  [DNA](repeating: DNA(), count:totalPopulation)
        
        // Seed
        for i in 0..<totalPopulation
        {
            population[i] = DNA()
        }
        
        
        // loop
        mainLoop: for loop in 0..<5000
        {
            
            for i in 0..<totalPopulation
            {
                population[i].fitness = world.fitness(dna: population[i])
            }
            
            var matingPool:[DNA] = [DNA]()
            // add item n times so we can pick a random item with 
            // higher chances based on fitness
            for i in 0..<totalPopulation
            {
                let n = Int(population[i].fitness * 100)
                let bulk = [DNA](repeating: population[i], count:n)
                matingPool.append(contentsOf: bulk)
            }
            
            // mate partners
            for i in 0..<totalPopulation
            {
                let a = Int(arc4random_uniform(UInt32(matingPool.count)))
                let b = Int(arc4random_uniform(UInt32(matingPool.count)))
                
                let partnerA = matingPool[a]
                let partnerB = matingPool[b]
                
                // share traits
                var child = partnerA.crossover(partner: partnerB)
                
                // mutate
                child.mutate(mutationRate: mutationRate)
                
                // overwrite old population
                population[i] = child
            }
            
            // do we have a result?
            for i in 0..<totalPopulation
            {
                if population[i].toString() == target
                {
                    print("Found \(loop) \(population[i].toString())")
                    break mainLoop
                }
            }
            
            print("\(loop) -> \(population[0].toString())")
            
        }
        
    }
    
}
