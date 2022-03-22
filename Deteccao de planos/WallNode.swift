//
//  WallNode.swift
//  Deteccao de planos
//
//  Created by Gabriel Oliveira Borges on 19/03/22.
//

import Foundation
import ARKit

class WallNode: SCNNode  {
    private let meshNode: SCNNode
    
    init(anchor: ARPlaneAnchor, sceneView: ARSCNView) {
        meshNode = SCNNode()
        super.init()
        
        guard let geometry = ARSCNPlaneGeometry(device: sceneView.device!) else {
            fatalError("Não foi possível criar o plano")
        }
        
        geometry.update(from: anchor.geometry)
        meshNode.geometry = geometry
        meshNode.opacity = 0.5
        meshNode.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
        addChildNode(meshNode)
    }
    
    required init(coder: NSCoder) {
        fatalError("init coder não implementado")
    }
    
    func getMeshNode() -> SCNNode {
        return meshNode
    }
}
