import { JSX, useState } from 'react'
import  axios from 'axios'

//19639 Lanview Ln, Santa Clarita, California, 91350

const API_DOMAIN = 'https://api.opencagedata.com/geocode/v1/json';
const KEY='1a932183b7ad4c408e5ef4dd63f7315e'

function App() {
    const [address, setAddress] = useState('');
    const [queryRes, setQueryRes] = useState<any>(null);

    const handleSubmit = async () => {
        if (!address.trim()) return;
        
        try {
            console.log("Submitting address:", address);
            const response = await axios.get(`${API_DOMAIN}?q=${address}&key=${KEY}`);
            console.log(response.data);
            console.log(typeof response.data);
            setQueryRes(response.data);
            // Process the response data as needed
        } catch (error) {
            console.error("Error submitting address:", error);
        }
    }

    function render_map (): JSX.Element {
        if (!queryRes) return (
            <></>
        )
        const latitude = queryRes.results[0].geometry.lat
        const longitude = queryRes.results[0].geometry.lng

        const factor = 0.0025

        return (
            <>
                <iframe 
                    width="100%" 
                    height="100%" 
                    src={`https://www.openstreetmap.org/export/embed.html?bbox=${longitude+factor}%2C${latitude+factor}%2C${longitude-factor}%2C${latitude-factor}&amp;layer=mapnik`}
                >
                </iframe><br/><small><a href="https://www.openstreetmap.org/?#map=17/34.442676/-118.480623">View Larger Map</a></small>
            </>
        )

    }

    return (
        <>  
        <div className="justify-center items-center flex h-screen" >
            <div className='flex flex-col'>
                <div className='flex items-center w-[600px] flex-col mb-4
                                gap-6 bg-gray-100 p-4 rounded-md'>

                    <h1 className="text-md font-regular">
                        Input an address below<br/>
                        19639 Lanview Ln, Santa Clarita, California, 91350
                    </h1>
                    <input 
                        type="text" 
                        className="flex flex-grow w-[560px] border-1 border-gray-400 bg-white p-2 rounded-md" 
                        placeholder='123 main st, Los Angeles, CA'
                        value={address}
                        onChange={(e) => setAddress(e.target.value)}
                    />
                    <button 
                        className="bg-blue-500 text-white p-2 rounded-md w-48 hover:bg-blue-600"
                        onClick={handleSubmit}
                    >
                        Submit
                    </button>

                </div>

                <div className={`max-h- w-[600px] mb-4 bg-gray-100 rounded-md overflow-hidden ${queryRes ? 'h-[400px]' : 'h-0'}`}>
                    {render_map()}
                </div>

                <div className="flex justify-center items-center w-[600px]">
                    <div className="bg-gray-100 p-2 rounded-md flex-grow">
                        {queryRes ? (
                            <div className="text-md font-regular text-gray-800 flex flex-col gap-2">
                                <p><strong>Address:</strong> {queryRes.results[0].formatted}</p>
                                <p><strong>Latitude:</strong> {queryRes.results[0].geometry.lat}</p>
                                <p><strong>Longitude:</strong> {queryRes.results[0].geometry.lng}</p>
                                <p><strong>DMS:</strong> {
                                    queryRes.results[0].annotations.DMS.lat + ' ' +
                                    queryRes.results[0].annotations.DMS.lng
                                }</p>
                                <p><strong>FIPS county:</strong> {queryRes.results[0].annotations.FIPS.county}</p>
                                <p><strong>Timezone:</strong> {queryRes.results[0].annotations.timezone.name}</p>
                                <p><strong>Timestamp:</strong> {new Date(queryRes.timestamp.created_http).toLocaleString()}</p>
                            </div>
                        ) : (
                            <p className="text-gray-500">Enter an address and submit to see results</p>
                        )}
                    </div>
                </div>

            </div>
        </div>
        </>
    )
}

export default App
