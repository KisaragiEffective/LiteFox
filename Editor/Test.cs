using System.Linq;
using UnityEditor;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;

// TODO: VRChatBuildPipelineCallbackでマスクテクスチャをR8 onlyにする
namespace LiteFox.Editor
{
    internal class Test : EditorWindow
    {
        [MenuItem("Tools/LiteFox/debug")]
        private static void OnMenu()
        {
            GetWindow<Test>().Show();
        }

        private void CreateGUI()
        {
            var o = new ObjectField("mesh") { objectType = typeof(Mesh) };
            
            rootVisualElement.Add(o);
            var b = new Button(() => { GenerateObjectSpaceVertexMapping(o.value as Mesh); });
            rootVisualElement.Add(b);
            b.Add(new Label("run"));
        }

        private void GenerateObjectSpaceVertexMapping(Mesh a)
        {
            var vertexPositionInLocalSpace = a.vertices;
            Debug.Log("x: " + vertexPositionInLocalSpace.Min(v3 => v3.x) + " .. " + vertexPositionInLocalSpace.Max(v3 => v3.x));
            Debug.Log("y: " + vertexPositionInLocalSpace.Min(v3 => v3.y) + " .. " + vertexPositionInLocalSpace.Max(v3 => v3.y));
            Debug.Log("z: " + vertexPositionInLocalSpace.Min(v3 => v3.z) + " .. " + vertexPositionInLocalSpace.Max(v3 => v3.z));
        }
    }
}