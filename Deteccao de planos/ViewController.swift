//
//  ViewController.swift
//  Deteccao de planos
//
//  Created by Gabriel Oliveira Borges on 19/03/22.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var slider: UISlider!
    
    private var sliderValue: CGFloat {
        get {
            return CGFloat(slider.value/10)
        }
    }
    private var selectedNode: SCNNode? = nil
    private let colors: [UIColor] = [.blue, .red, .yellow, .green, .white, .black, .magenta, .orange, .purple]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupScene()
    }

    private func setupScene() {
        let sceneConfiguration = ARWorldTrackingConfiguration()
        sceneConfiguration.planeDetection = .vertical
        sceneView.session.run(sceneConfiguration)
        sceneView.delegate = self
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        
        self.sceneView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTapNode))
        )
    }
    
    private func setupCollectionView() {
        collectionView.register(ColorsCollectionViewCell.nib, forCellWithReuseIdentifier: ColorsCollectionViewCell.identifier)
        collectionView.dataSource = self
    }
    
    @objc private func didTapNode(sender: UITapGestureRecognizer) {
        let tappedSceneView = sender.view as! SCNView
        let touchCoordenates = sender.location(in: tappedSceneView)
        let hitTest = tappedSceneView.hitTest(touchCoordenates)
        
        guard let tappedNode = hitTest.first?.node, sceneView.anchor(for: tappedNode) is ARPlaneAnchor, tappedNode.geometry is ARSCNPlaneGeometry else { return }
        
        if (tappedNode == selectedNode) {
            selectedNode = nil
            tappedNode.opacity = 0.5
            tappedNode.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
        } else {
            selectedNode = tappedNode
            selectedNode?.opacity = sliderValue
            tappedNode.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
        }
    }
    
    
    @IBAction func onSliderChange(_ sender: Any) {
        if let selectedNode = selectedNode {
            selectedNode.opacity = sliderValue
        }
    }
    
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let wallNode = WallNode(anchor: planeAnchor, sceneView: self.sceneView)
        
        node.addChildNode(wallNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        guard let wallNode = node.childNodes.first as? WallNode else { return }
        
        if let planeGeometry = wallNode.getMeshNode().geometry as? ARSCNPlaneGeometry {
            planeGeometry.update(from: planeAnchor.geometry)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        node.childNodes.forEach { child in
            child.removeFromParentNode()
        }
        
        node.removeFromParentNode()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorsCollectionViewCell.identifier, for: indexPath) as? ColorsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let selectedColor = colors[indexPath.row]
        cell.configure(selectedColor) { selectedColor in
            self.selectedNode?.geometry?.firstMaterial?.diffuse.contents = selectedColor
        }
        
        return cell
    }
}

