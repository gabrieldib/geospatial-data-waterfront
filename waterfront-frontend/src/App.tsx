import { useEffect } from 'react'
import  axios from 'axios'

function App() {
    const fetchAPI = async () => {
        const response = await axios.get("http://localhost:3000/api/v1/hello")
        console.log(response.data)
    }

    useEffect(() => {
        fetchAPI()
    }, [])

    return (
        <>
            <h1 className="text-3xl font-bold underline">
                Hello world!
            </h1>
        </>
    )
}

export default App
